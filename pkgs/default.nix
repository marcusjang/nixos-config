pkgs: with pkgs; {
	birdtray = callPackage ./birdtray.nix { };
	deno-bin = callPackage ./deno-bin.nix { };
	gulim = callPackage ./gulim.nix { };
	batang = callPackage ./batang.nix { };
	hop = callPackage ./hop.nix { };
	kime = callPackage ./kime.nix { };
	scriptorium = callPackage ./scriptorium.nix { };
	tls-client = callPackage ./tls-client.nix { };
}
