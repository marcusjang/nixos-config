final: prev: with final; let 
	fetchLibrustyV8 = args: fetchurl {
		name = "librusty_v8-${args.version}";
		url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_simdutf_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
		sha256 = args.shas.${stdenv.hostPlatform.system};
		meta = {
			inherit (args) version;
			sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
		};
	};
in with final; {
	deno = prev.unstable.deno.overrideAttrs (finalAttrs: prevAttrs: rec {
		pname = prevAttrs.pname;
		version = "2.7.12";
		src = fetchFromGitHub {
			owner = "denoland";
			repo = "deno";
			tag = "v${version}";
			hash = "sha256-yWSkgA5pXOtuN4ubDm0DlKVOKxHz3Bovd3gsWNoxjqo=";
		};
		cargoDeps = rustPlatform.fetchCargoVendor {
			inherit pname version src nativeBuildInputs;
			hash = "sha256-YahHLz4ykAcFNrh/GFVJ0fZtCNHKG9RzdCUprQDfOUo=";
		};
		env.RUSTY_V8_ARCHIVE = fetchLibrustyV8 {
			version = "147.0.0";
			shas.x86_64-linux = "sha256-PXLRowkOBRVWeonQDTN6e4BQlSLK/kobCX7eE0Y1NLY=";
		};
	});
}
