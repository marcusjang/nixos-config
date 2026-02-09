{
	description = "marcus@nixos";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		hardware.url = "github:nixos/nixos-hardware";
		wsl.url = "github:nix-community/NixOS-WSL";
		niri.url = "github:sodiboo/niri-flake";
		ghostty = {
			url = "github:ghostty-org/ghostty?ref=pull/10459/head";
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
					./modules/audio.nix
					./modules/desktop.nix
					./modules/gnome.nix
					./modules/i18n.nix
					./modules/firewall.nix
					./modules/mounts.nix
					./modules/games.nix
					sops-nix.nixosModules.sops
				];
			};
			x1c13 = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				modules = [
					./hosts/x1c13
					./users/marcus.nix
					./modules/audio.nix
					./modules/desktop.nix
					./modules/gnome.nix
					./modules/i18n.nix
					./modules/firewall.nix
					./modules/suspend.nix
					./modules/mounts.nix
					./modules/wireguard.nix
					sops-nix.nixosModules.sops
				];
			};
			minibook = nixpkgs-unstable.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				modules = [
					./hosts/minibook
					./users/marcus.nix
					./modules/audio.nix
					./modules/desktop.nix
					./modules/gnome.nix
					./modules/i18n.nix
					./modules/mounts.nix
					./modules/firewall.nix
					./modules/suspend.nix
					./modules/mounts.nix
					./modules/wireguard.nix
					sops-nix.nixosModules.sops
				];
			};
			wsl = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs outputs; };
				modules = [
					./hosts/wsl
					./users/marcus.nix
					sops-nix.nixosModules.sops
				];
			};
			nas = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				modules = [
					./hosts/nas
					./modules/ssh.nix
					./modules/samba.nix
					./modules/firewall.nix
					./users/marcus.nix
					sops-nix.nixosModules.sops
				];
			};
		};
	};
}
