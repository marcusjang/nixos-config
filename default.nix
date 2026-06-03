{
	system ? builtins.currentSystem,
	config ? {},
	overlays ? [],
	...
}: let
	flake = (import (let
		lock = builtins.fromJSON (builtins.readFile ./flake.lock);
		nodeName = lock.nodes.root.inputs.flake-compat;
	in fetchTarball {
		url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.${nodeName}.locked.rev}.tar.gz";
		sha256 = lock.nodes.${nodeName}.locked.narHash;
	}) { src = ./.; }).defaultNix;

	baseOverlays = with flake.outputs.overlays; [
		additions
		unstable-packages
		nixpkgs-patched
	] ++ builtins.attrValues flake.outputs.overlays;
in import (flake.inputs.nixpkgs.outPath) {
	inherit system config;
	overlays = baseOverlays ++ overlays;
}
