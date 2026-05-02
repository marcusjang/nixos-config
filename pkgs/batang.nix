{
	lib,
	stdenvNoCC,
	fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
	pname = "batang";
	version = "1.0.0";
	src = fetchFromGitHub {
		owner = "googlefonts";
		repo = "batang";
		rev = "6c1e09f93204c963881afbb4e25699095565f2e5";
		hash = "sha256-1YFcb6LCqMHU+T/uhMqpRCFEMA9F2sTjL+V0FDae234=";
	};
	unpackPhase = ":";
	buildPhase = ":";
	doCheck = false;
	installPhase = ''
		runHook preInstall
		install -Dm444 $src/fonts/ttc/batang-Regular.ttc -t $out/share/fonts
		runHook postInstall
	'';

	meta = {
		description = "Batang Korean Font";
		homepage = "https://github.com/googlefonts/batang";
		license = lib.licenses.ofl;
		maintainers = [
			{
				email = "marcus@melange.works";
				github = "marcusjang";
				githubId = 10116562;
				name = "Marcus Jang";
			}
		];
	};
}


