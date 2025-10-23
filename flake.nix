{
	description = "marcus@nixos";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		hardware.url = "github:nixos/nixos-hardware";
		wsl.url = "github:nix-community/NixOS-WSL";
		sops-nix = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		ghostty = {
			type = "github";
			owner = "ghostty-org";
			repo = "ghostty";
			ref = "refs/tags/v1.2.2";
		};
	};

	outputs = { self, nixpkgs, sops-nix, ... } @ inputs: let
		inherit (self) outputs;
	in {
		overlays = import ./overlays { inherit inputs; };

		nixosModules.default = import ./modules;

		nixosConfigurations = {
			ser8 = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				system = "x86_64-linux";
				modules = [
					./hosts/ser8
					./users/marcus.nix
					./modules/audio.nix
					./modules/desktop.nix
					./modules/gnome.nix
					./modules/i18n.nix
					./modules/firewall.nix
					./modules/mounts.nix
					sops-nix.nixosModules.sops
				];
			};
			minibook = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				system = "x86_64-linux";
				modules = [
					./hosts/minibook
					./users/marcus.nix
					./modules/audio.nix
					./modules/desktop.nix
					./modules/gnome.nix
					./modules/i18n.nix
					./modules/mounts.nix
					./modules/firewall.nix
					./modules/wireguard.nix
					sops-nix.nixosModules.sops
				];
			};
			wsl = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				system = "x86_64-linux";
				modules = [
					./hosts/wsl
					./users/marcus.nix
					sops-nix.nixosModules.sops
				];
			};
			nas = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				system = "x86_64-linux";
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
