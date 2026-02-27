{ ... }:
final: prev: {
	legcord = prev.legcord.overrideAttrs (finalAttrs: prevAttrs: rec {
		pname = prevAttrs.pname;
		version = "1.2.2";
		src = final.pkgs.fetchFromGitHub {
			owner = "Legcord";
			repo = "Legcord";
			tag = "v${version}";
			hash = "sha256-i4Pw1jvkRYCQg1+9eZVi30Qblpttz9V+k//zehBZGDM=";
		};
		pnpmDeps = final.pkgs.fetchPnpmDeps {
			inherit (finalAttrs) pname version src;
			fetcherVersion = 3;
			hash = "sha256-9sdN5tbCCe/euTo8zRkU0C3yQ8sAufPyN8a4GeJW/Us=";
		};
		autoPatchelfIgnoreMissingDeps = [ "*" ];
	});
}
