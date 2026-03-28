{ ... }:
final: prev: {
	libhangul = prev.libhangul.overrideAttrs (finalAttrs: prevAttrs: rec {
		pname = prevAttrs.pname;
		version = "0.2.0";
		src = final.pkgs.fetchFromGitHub {
			owner = "libhangul";
			repo = "libhangul";
			tag = "libhangul-${version}";
			hash = "sha256-1cTDsRJpT5TLdJN8D2LfOISWeAOlSO6zKZOaCrTxooM=";
		};
		nativeBuildInputs = with final.pkgs; [
			autoreconfHook
			pkg-config
		];
		patches = [ ./patches/libhangul.patch ];
		preAutoreconf = "touch ChangeLog";
#        configurePhase = ''
#		    ./autogen.sh
#			./configure
#        '';
	});
}
