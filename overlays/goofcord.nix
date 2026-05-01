final: prev: with final; {
	goofcord = prev.unstable.goofcord.overrideAttrs (prevAttrs: rec {
		inherit (prevAttrs) pname;
		version = "2.2.1";
		src = fetchFromGitHub {
			owner = "Milkshiift";
			repo = "GoofCord";
			tag = "v${version}";
			hash = "sha256-qcgEUkPh671q9aJtge+PSbBTrg7vY+iz+H+SKXPFqFI=";
		};
		nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ pkgs.jq ];
		postPatch = ''
			mv ./package.json ./package.json.old
			jq '.desktopName = "GoofCord"' ./package.json.old > ./package.json
			rm ./package.json.old
		'';
		desktopItems = [
			((builtins.elemAt prevAttrs.desktopItems 0).override { icon = "discord"; })
		];
	});
}

