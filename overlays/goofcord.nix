final: prev: with final; {
	goofcord = (prev.unstable.goofcord.override {
		electron = final.electron_44;
	}).overrideAttrs (finalAttrs: prevAttrs: {
		inherit (prevAttrs) pname;
		version = "2.3.1";
		src = fetchFromGitHub {
			owner = "Milkshiift";
			repo = "GoofCord";
			tag = "v${finalAttrs.version}";
			hash = "sha256-958TIiBsXYTfYaQdNKeVJspdSE1vIYMX/wScfqekTBU=";
		};
		node-modules = let
			goofcord = finalAttrs;
		in prevAttrs.node-modules.overrideAttrs (finalAttrs: prevAttrs: {
			inherit (goofcord) version src;
			pname = goofcord.pname + "-modules";

			outputHash = {
				x86_64-linux = "sha256-J9ECsmgIhUfLfSEk6TBJYGi7V6GsM0YbspmTxNO9L8U=";
				aarch64-linux = "sha256-ss25YGAezqAfo57jE4pkekr+6O9UK4CIxcOgb7GCIV8=";
			}.${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");
		});
		nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ pkgs.jq ];
		buildPhase = lib.replaceStrings [
			"electron-builder/out"
			"-c.npmRebuild"
		] [
			"electron-builder/dist"
			"-c.nativeModules.npmRebuild"
		] prevAttrs.buildPhase;
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

