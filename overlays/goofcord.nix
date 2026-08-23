final: prev: with final; {
	goofcord = (prev.unstable.goofcord.override {
		electron = final.electron_42;
	}).overrideAttrs (finalAttrs: prevAttrs: {
		inherit (prevAttrs) pname;
		version = "2.3.0";
		src = fetchFromGitHub {
			owner = "Milkshiift";
			repo = "GoofCord";
			tag = "v${finalAttrs.version}";
			hash = "sha256-cg9NVL/dPIQ9xyMrUmWd42HxEsTSnhUGiqB7qaU2LuQ=";
		};
		node-modules = let
			goofcord = finalAttrs;
		in prevAttrs.node-modules.overrideAttrs (finalAttrs: prevAttrs: {
			inherit (goofcord) version src;
			pname = goofcord.pname + "-modules";

			outputHash = {
				x86_64-linux = "sha256-J26DRSUa/C7lvI8JFPQ92yj4zUVnD+SPkKwRQA9ITB8=";
				aarch64-linux = "sha256-WIjcl//+OGB5J6Dp4Q2x24MA/cWqdtHYNwBBOgCD/tU=";
			}.${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");
		});
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

