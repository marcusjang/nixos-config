{
	description = "marcus@nixos";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		hardware.url = "github:nixos/nixos-hardware";
		wsl.url = "github:nix-community/NixOS-WSL/main";
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

	outputs = { self, nixpkgs, sops-nix, ... } @ inputs: let
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
	};
}
