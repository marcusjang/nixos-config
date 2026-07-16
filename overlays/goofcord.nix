final: prev: with final; {
	goofcord = prev.unstable.goofcord.overrideAttrs (finalAttrs: prevAttrs: {
		inherit (prevAttrs) pname;
		version = "2.2.2";
		src = fetchFromGitHub {
			owner = "Milkshiift";
			repo = "GoofCord";
			tag = "v${finalAttrs.version}";
			hash = "sha256-PwPDm/ay1df+tqpKzLMP64GOB4F/dgFm0xaT9x0yVGE=";
		};
		node-modules = let
			goofcord = finalAttrs;
		in prevAttrs.node-modules.overrideAttrs (finalAttrs: prevAttrs: {
			inherit (goofcord) version src;
			pname = goofcord.pname + "-modules";

			outputHash = {
				x86_64-linux = "sha256-Gi9QO6FYgcpAEtVVMvkq/ihnYhovSmfhsqE2UnxYBaw=";
				aarch64-linux = "sha256-+WpYaPp72BFV8j+gXJrmd52qtqkSf76tPEE40jzsqEs=";
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

