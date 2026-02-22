{
	description = "marcus@nixos";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		hardware.url = "github:nixos/nixos-hardware";
		wsl.url = "github:nix-community/NixOS-WSL";
		niri.url = "github:sodiboo/niri-flake";
		ghostty = {
			#url = "github:ghostty-org/ghostty?ref=tip";
			url = "github:ghostty-org/ghostty?ref=861a9cf537a58a380bc6a0784573b3de3a70415e";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};
		sops-nix = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, nixpkgs-unstable, sops-nix, ... } @ inputs: let
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
					./modules/locale.nix
					./modules/firewall.nix
					./modules/mounts.nix
					./modules/desktop
					./modules/desktop/audio.nix
					./modules/desktop/fonts.nix
					./modules/desktop/games.nix
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
					./modules/locale.nix
					./modules/firewall.nix
					./modules/mounts.nix
					./modules/wireguard.nix
					./modules/desktop
					./modules/desktop/audio.nix
					./modules/desktop/fonts.nix
					./modules/desktop/office.nix
					./modules/desktop/suspend.nix
					./modules/desktop/de/gnome.nix
					./modules/desktop/ime/ibus.nix
					sops-nix.nixosModules.sops
				];
			};
			minibook = nixpkgs-unstable.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				modules = [
					./hosts/minibook
					./users/marcus.nix
					./modules/locale.nix
					./modules/mounts.nix
					./modules/firewall.nix
					./modules/mounts.nix
					./modules/wireguard.nix
					./modules/desktop
					./modules/desktop/audio.nix
					./modules/desktop/fonts.nix
					./modules/desktop/suspend.nix
					./modules/desktop/de/gnome.nix
					./modules/desktop/ime/ibus.nix
					sops-nix.nixosModules.sops
				];
			};
			wsl = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs outputs; };
				modules = [
					./hosts/wsl
					./users/marcus.nix
					./modules/mounts.nix
					sops-nix.nixosModules.sops
				];
			};
			nas = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				modules = [
					./hosts/nas
					./users/marcus.nix
					./modules/server
					./modules/server/ssh.nix
					./modules/server/samba.nix
					./modules/server/traefik.nix
					./modules/server/homebridge.nix
					./modules/server/webdav.nix
					./modules/server/mylar3.nix
					./modules/server/komga.nix
					sops-nix.nixosModules.sops
				];
			};
		};
	};
}
