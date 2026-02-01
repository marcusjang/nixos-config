{ ... }:
final: prev: {
	legcord = prev.legcord.overrideAttrs (finalAttrs: prevAttrs: rec {
		pname = prevAttrs.pname;
		version = "1.2.1";
		src = final.pkgs.fetchFromGitHub {
			owner = "Legcord";
			repo = "Legcord";
			tag = "v${version}";
			hash = "sha256-196AE244jEZNfhkC+vouNq9M7DOd3kk/1JLW1XRLOHA=";
	  	};
		pnpmDeps = final.pkgs.pnpm.fetchDeps {
			inherit (finalAttrs) pname version src;
			fetcherVersion = 1;
			hash = "sha256-ksClxW8dIV72Hky5RFJ6cpPAteL29Cx8Me0aG5V/Y4k=";
		};
		autoPatchelfIgnoreMissingDeps = [ "*" ];
	});
}
