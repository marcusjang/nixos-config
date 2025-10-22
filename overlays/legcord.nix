{ ... }:
final: prev: {
	legcord = prev.legcord.overrideAttrs (finalAttrs: prevAttrs: rec {
		pname = prevAttrs.pname;
		version = "1.1.6";
		src = final.pkgs.fetchFromGitHub {
			owner = "Legcord";
			repo = "Legcord";
			#tag = "v${version}";
			rev = "79bddf3d940b611d200ee4e808816583e801327e";
			hash = "sha256-oYG33+s0VVboXjhuOfphAzbnUwwOSQmEIY1TopiQw5Q=";
	  	};
		pnpmDeps = final.pkgs.pnpm.fetchDeps {
			inherit (finalAttrs) pname version src;
			fetcherVersion = 1;
			hash = "sha256-GF/pdbHWnese772wpZ0CoKqB5+YqskJvl1IO+1TIMO0=";
		};
		autoPatchelfIgnoreMissingDeps = [ "*" ];
	});
}
