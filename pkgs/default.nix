pkgs: with pkgs; {
	birdtray = callPackage ./birdtray.nix { };
	deno-bin = callPackage ./deno-bin.nix { };
	gulim = callPackage ./gulim.nix { };
	hop = callPackage ./hop.nix { };
}
