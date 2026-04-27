{
	description = "marcus@nixos";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		hardware.url = "github:nixos/nixos-hardware";
		wsl.url = "github:nix-community/NixOS-WSL/main";
		harmonia.url = "github:nix-community/harmonia?ref=0327e9d607d42ccafaad2f1b24fabec8ab99fd9f";
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
		pkgs = import nixpkgs-unstable {
			inherit system;
			overlays = with outputs.overlays; [
				additions
				unstable-packages
				nixpkgs-patched
			] ++ builtins.attrValues outputs.overlays;
		};
	in with pkgs; {
		packages = pkgs;

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

					HEAD=$(git rev-parse --short=8 HEAD)
					TIME=$(git show -s --format=%ci)
					CACHE_URL="ssh-ng://marcus@n5.local"
					echo -e "\x1b[92m\033[1minfo: \033[0m\x1b[0mBuilding $HEAD ($TIME)..."
					echo -e "\x1b[92m\033[1minfo: \033[0m\x1b[0mLocal cache at: $CACHE_URL"

					readarray -t HOSTS < <(echo ${with builtins; lib.escapeShellArg (
						toJSON (attrNames outputs.nixosConfigurations)
					)} | ${lib.getExe pkgs.jq} -r '.[]')

					for host in "''${HOSTS[@]}"; do
						DERIVATION=".#nixosConfigurations.$host.config.system.build.toplevel"

						BUILD_MSG="\x1b[32m\033[1mbuilding: \033[0m\x1b[0mBuilding $host..."
						echo -e $BUILD_MSG
						nix build \
							--no-warn-dirty \
							--no-link \
							$DERIVATION \
						|| (echo -e "\x1b[31m\033[1merror: \033[0m\x1b[0mBuild error, halting..."; exit 1)
						echo -e "\e[1A\r\e[K$BUILD_MSG Done!"

						COPY_MSG="\x1b[34m\033[1mcopying: \033[0m\x1b[0mCopying $host over to local cache..."
						echo -e $COPY_MSG
						nix copy \
							--no-warn-dirty \
							--substitute-on-destination \
							--to $CACHE_URL \
							--no-check-sigs \
							$DERIVATION
						echo -e "\e[1A\r\e[K$COPY_MSG Done!"
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
