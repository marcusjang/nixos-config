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
		wireguard
	]) ++ (with outputs.nixosModules.desktop; [
		common
		audio
		fonts
		office
		printing
		suspend
		de.gnome
		ime.ibus-hangul
	]);
}
