{
	description = "marcus@nixos";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		hardware.url = "github:nixos/nixos-hardware";
		wsl.url = "github:nix-community/NixOS-WSL/main";
		harmonia.url = "github:nix-community/harmonia?ref=harmonia-v3.3.0";
		flake-utils.url = "github:numtide/flake-utils";
		flake-compat.url = "github:edolstra/flake-compat";
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
	in {
		legacyPackages = pkgs;
	});
}
