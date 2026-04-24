{
	description = "marcus@nixos";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		hardware.url = "github:nixos/nixos-hardware";
		wsl.url = "github:nix-community/NixOS-WSL/main";
		harmonia.url = "github:nix-community/harmonia?ref=harmonia-v3.0.0";
		flake-utils.url = "github:numtide/flake-utils";
		copyparty.url = "github:9001/copyparty";
		niri.url = "github:sodiboo/niri-flake";
		ghostty.url = "github:ghostty-org/ghostty?ref=v1.3.1";
		disko = {
			url = "github:nix-community/disko/latest";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		disko-zfs = {
			url = "github:numtide/disko-zfs";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.disko.follows = "disko";
		};
		sops-nix = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, nixpkgs-unstable, sops-nix, flake-utils, ... } @ inputs: 
	flake-utils.lib.eachDefaultSystemPassThrough (system: let
		inherit (self) outputs;
	in {
		overlays = import ./overlays { inherit inputs; };

		nixosModules.default = import ./modules;

		nixosConfigurations = {
			ser8 = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				modules = [
					./hosts/ser8
					./users/marcus.nix
					./modules/harmonia.nix
					./modules/locale.nix
					./modules/firewall.nix
					./modules/mounts.nix
					./modules/desktop
					./modules/desktop/audio.nix
					./modules/desktop/fonts.nix
					./modules/desktop/office.nix
					./modules/desktop/games.nix
					./modules/desktop/printing.nix
					./modules/desktop/uxplay.nix
					./modules/desktop/de/gnome.nix
					./modules/desktop/ime/ibus.nix
					sops-nix.nixosModules.sops
				];
			};
			x1c13 = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				modules = [
					./hosts/x1c13
					./users/marcus.nix
					./modules/harmonia.nix
					./modules/locale.nix
					./modules/firewall.nix
					./modules/mounts.nix
					./modules/wireguard.nix
					./modules/desktop
					./modules/desktop/audio.nix
					./modules/desktop/fonts.nix
					./modules/desktop/office.nix
					./modules/desktop/suspend.nix
					./modules/desktop/printing.nix
					./modules/desktop/de/gnome.nix
					./modules/desktop/ime/ibus.nix
					sops-nix.nixosModules.sops
				];
			};
			minibook = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				modules = [
					./hosts/minibook
					./users/marcus.nix
					./modules/harmonia.nix
					./modules/locale.nix
					./modules/mounts.nix
					./modules/firewall.nix
					./modules/mounts.nix
					./modules/wireguard.nix
					./modules/desktop
					./modules/desktop/audio.nix
					./modules/desktop/fonts.nix
					./modules/desktop/suspend.nix
					./modules/desktop/printing.nix
					./modules/desktop/de/gnome.nix
					./modules/desktop/ime/ibus.nix
					sops-nix.nixosModules.sops
				];
			};
			wsl = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs outputs; };
				modules = [
					inputs.wsl.nixosModules.default
					./hosts/wsl
					./users/marcus.nix
					./modules/mounts.nix
					./modules/harmonia.nix
					sops-nix.nixosModules.sops
				];
			};
			n5 = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				modules = [
					inputs.disko.nixosModules.disko
					inputs.disko-zfs.nixosModules.default
					inputs.copyparty.nixosModules.default
					./hosts/n5
					./users/marcus.nix
					./users/git.nix
					./modules/server
					./modules/server/ssh.nix
					./modules/server/samba.nix
					./modules/server/traefik.nix
					./modules/server/harmonia.nix
					./modules/server/cloudflared.nix
					./modules/server/homebridge.nix
					./modules/server/webdav.nix
					./modules/server/mylar3.nix
					./modules/server/komga.nix
					./modules/server/copyparty.nix
					sops-nix.nixosModules.sops
				];
			};
			nas400 = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				modules = [
					inputs.copyparty.nixosModules.default
					./hosts/nas400
					./users/marcus.nix
					./modules/server
					./modules/server/ssh.nix
					./modules/server/samba.nix
					./modules/server/traefik.nix
					./modules/server/homebridge.nix
					./modules/server/webdav.nix
					./modules/server/mylar3.nix
					./modules/server/komga.nix
					./modules/server/copyparty.nix
					sops-nix.nixosModules.sops
				];
			};
		};
	}) //
	flake-utils.lib.eachDefaultSystem (system: let
		inherit (self) outputs;
		pkgs = import nixpkgs-unstable { inherit system; };
	in with pkgs; {
		packages = import ./pkgs pkgs;

		apps = {
			update-inputs = {
				type = "app";
				program = toString (writeShellScript "update-inputs" ''
					git diff-index --quiet HEAD -- >/dev/null 2>&1; ec=$?
					if test "$ec" = 0; then
						nix flake update
						git add flake.lock
						git commit -m "Update flake inputs"
					elif test "$ec" = 1; then
						exit
					else
						echo "Error from diff-index, cancelling..."
					fi
				'');
			};
			build = {
				type = "app";
				program = toString (writeShellScript "build" ''
					set -e
					trap "break" SIGINT SIGHUP SIGTERM
					git pull --quiet
					readarray -t HOSTS < <(echo ${with builtins; lib.escapeShellArg (toJSON (attrNames outputs.nixosConfigurations))} | ${lib.getExe pkgs.jq} -r '.[]')
					for host in "''${HOSTS[@]}"; do
						derivation=".#nixosConfigurations.$host.config.system.build.toplevel"
						echo "Building $host..."
						nix build --no-warn-dirty --no-link $derivation || (echo "Build error, halting..."; exit 1)
						echo "Done building $host!"
						echo "Copying over to local cache..."
						nix copy --no-warn-dirty --substitute-on-destination --to ssh-ng://marcus@n5.local --no-check-sigs $derivation
						echo "Done!"
					done
				'');
			};
			update = {
				type = "app";
				program = toString (writeShellScript "update" ''
					git pull --quiet
					nixos-rebuild --option warn-dirty false --flake . --sudo --ask-sudo-password $1
				'');
			};
			update-nas = {
				type = "app";
				program = toString (writeShellScript "update-nas" ''
					nixos-rebuild --option warn-dirty false --target-host marcus@n5.local --flake . --sudo --ask-sudo-password $1
				'');
			};
		};
	});
}
