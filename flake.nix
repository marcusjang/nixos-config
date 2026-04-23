{
	description = "marcus@nixos";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		hardware.url = "github:nixos/nixos-hardware";
		wsl.url = "github:nix-community/NixOS-WSL/main";
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
		pkgs = import nixpkgs-unstable { inherit system; };
	in {
		packages = import ./pkgs pkgs;

		apps = {
			update-inputs = {
				type = "app";
				program = toString (pkgs.writeShellScript "update-inputs" ''
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
				program = toString (pkgs.writeShellScript "build" ''
					trap "break" SIGINT SIGHUP SIGTERM
					git pull --quiet
					readarray -t HOSTS < <(nix eval .#nixosConfigurations --json --apply "builtins.attrNames" | nix run nixpkgs#jq -- -r '.[]')
					for host in "''${HOSTS[@]}"; do
						echo "Building $host..."
						nix build --store ssh-ng://marcus@n5.local ".#nixosConfigurations.$host.config.system.build.toplevel"
						echo "Done building $host!"
					done
				'');
			};
			update = {
				type = "app";
				program = toString (pkgs.writeShellScript "update" ''
					git pull --quiet
					nixos-rebuild --flake . --sudo --ask-sudo-password $1
				'');
			};
			update-nas = {
				type = "app";
				program = toString (pkgs.writeShellScript "update-nas" ''
					nixos-rebuild --target-host marcus@n5.local --flake . --sudo --ask-sudo-password $1
				'');
			};
		};
	});
}
