final: prev: with final; {
	libhangul = prev.libhangul.overrideAttrs (finalAttrs: prevAttrs: rec {
		inherit (prevAttrs) pname;
		version = "0.2.0";
		src = fetchFromGitHub {
			owner = "libhangul";
			repo = "libhangul";
			tag = "libhangul-${version}";
			hash = "sha256-1cTDsRJpT5TLdJN8D2LfOISWeAOlSO6zKZOaCrTxooM=";
		};
		nativeBuildInputs = with pkgs; [
			autoreconfHook
			pkg-config
		];
		patches = [ ./patches/libhangul.patch ];
		preAutoreconf = "touch ChangeLog";
	});
}
