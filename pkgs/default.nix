pkgs: with pkgs; {
	deno-bin = callPackage ./deno-bin.nix { };
	gulim = callPackage ./gulim.nix { };
	hop = callPackage ./hop.nix { };
}
