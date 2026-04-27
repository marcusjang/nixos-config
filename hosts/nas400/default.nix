{ nixpkgs, inputs, outputs, ... }:
nixpkgs.lib.nixosSystem {
	specialArgs = { inherit inputs outputs; };
	modules = [
		./configuration.nix
	] ++ (with inputs; [
		wsl.nixosModules.default
		copyparty.nixosModules.default
		sops-nix.nixosModules.sops
	]) ++ (with outputs.nixosModules; [
		users.marcus
		users.git
	]) ++ (with outputs.nixosModules.server; [
		ssh
		samba
		traefik
		harmonia
		cloudflared
		homebridge
		webdav
		mylar3
		komga
		copyparty
	]);
}
