{ ... }:
final: prev: {
	legcord = prev.legcord.overrideAttrs (finalAttrs: prevAttrs: rec {
		pname = prevAttrs.pname;
		version = "1.2.1";
		src = final.pkgs.fetchFromGitHub {
			owner = "Legcord";
			repo = "Legcord";
			tag = "v${version}";
			rev = "79bddf3d940b611d200ee4e808816583e801327e";
			hash = "";
	  	};
		pnpmDeps = final.pkgs.pnpm.fetchDeps {
			inherit (finalAttrs) pname version src;
			fetcherVersion = 1;
			hash = "";
		};
		autoPatchelfIgnoreMissingDeps = [ "*" ];
	});
}
