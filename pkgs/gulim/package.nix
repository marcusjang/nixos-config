{
	lib,
	stdenvNoCC,
	fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
	pname = "gulim";
	version = "1.0.0";
	src = fetchFromGitHub {
		owner = "googlefonts";
		repo = "gulim";
		rev = "012723a8d5b6a6dc920330f26d165422c3014fd6";
		hash = "sha256-KW3YvbPuBtDLCRGEMKEBrJ/FamGLZxC9SBBrMDHCdGI=";
	};
	unpackPhase = ":";
	buildPhase = ":";
	doCheck = false;
	installPhase = ''
		runHook preInstall
		install -Dm444 $src/fonts/ttc/gulim-Regular.ttc -t $out/share/fonts
		runHook postInstall
	'';

	meta = {
		description = "Gulim Korean Font";
		homepage = "https://github.com/googlefonts/gulim";
		license = lib.licenses.ofl;
		maintainers = [ lib.importJSON ../maintainer.json ];
	};
}


