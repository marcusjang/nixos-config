{
	description = "marcus@nixos";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		hardware.url = "github:nixos/nixos-hardware";
		wsl.url = "github:nix-community/NixOS-WSL/main";
		harmonia.url = "github:nix-community/harmonia?ref=harmonia-v3.1.0";
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

	outputs = { self, flake-utils, ... } @ inputs: 
	flake-utils.lib.eachDefaultSystemPassThrough (system: let
		inherit (self) outputs;
	in {
		overlays = import ./overlays { inherit inputs; };
		nixosModules = import ./modules; 
		nixosConfigurations = import ./hosts { inherit inputs outputs; };
	}) //
	flake-utils.lib.eachDefaultSystem (system: let
		inherit (self) outputs;
		pkgs = import inputs.nixpkgs {
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
