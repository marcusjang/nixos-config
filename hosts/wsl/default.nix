{ nixpkgs, inputs, outputs, ... }:
nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	specialArgs = { inherit inputs outputs; };
	modules = [
		./configuration.nix
	] ++ (with inputs; [
		wsl.nixosModules.default
		sops-nix.nixosModules.sops
	]) ++ (with outputs.nixosModules; [
		users.marcus
		harmonia-client
		nas-mounts
	]);
}
