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
				x86_64-linux = "sha256-3iqlE0FOErXjqqY7K/jjCprLQK3gR4FyshHOUxiWfrc=";
				aarch64-linux = "sha256-+7MHKy2meigKfDPfQJiE0d8ugCqs4UOkSEUlie1seV4=";
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
		desktopItems = [
			((builtins.elemAt prevAttrs.desktopItems 0).override {
				icon = "discord";
				startupWMClass = "io.github.milkshiift.GoofCord";
			})
		];
	});
}

