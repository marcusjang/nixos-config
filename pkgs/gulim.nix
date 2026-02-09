{
	lib,
	stdenvNoCC,
	fetchurl,
}:

stdenvNoCC.mkDerivation rec {
	pname = "gulim";
	version = "1.0.0";

	src = fetchurl {
		url = "https://github.com/googlefonts/gulim/raw/refs/heads/main/fonts/ttf/bitmap/${pname}-Regular.ttf";
		hash = "sha256-61wDircP2YVrundnk/XbIU3HyipVWfczks8E7CsVGUY=";
	};

	installPhase = ''
		runHook preInstall
		install -m444 -Dt $out/share/fonts $src
		runHook postInstall
	'';

	meta = {
		description = "Gulim Korean Font";
		homepage = "https://github.com/googlefonts/gulim";
		license = lib.licenses.ofl;
	};
}


