pkgs: with pkgs; {
	birdtray = callPackage ./birdtray { };
	deno-bin = callPackage ./deno-bin { };
	gulim = callPackage ./gulim { };
	batang = callPackage ./batang { };
	hop = callPackage ./hop { };
	kime = callPackage ./kime { };
	scriptorium = callPackage ./scriptorium { };
	tls-client = callPackage ./tls-client { };
}
