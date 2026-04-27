{ nixpkgs, inputs, outputs, ... }:
nixpkgs.lib.nixosSystem {
	specialArgs = { inherit inputs outputs; };
	modules = [
		./configuration.nix
	] ++ (with inputs; [
		sops-nix.nixosModules.sops
	]) ++ (with outputs.nixosModules; [
		users.marcus
		harmonia-client
		locale
		firewall
		nas-mounts
	]) ++ (with outputs.nixosModules.desktop; [
		common
		audio
		fonts
		office
		games
		printing
		uxplay
		de.gnome
		ime.ibus-hangul
	]);
}

