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
		inherit (prevAttrs) pname;
		version = "2.7.13";
		src = fetchFromGitHub {
			owner = "denoland";
			repo = "deno";
			tag = "v${version}";
			hash = "sha256-LGTA2xwT939GlAaKfUU3XA0Jx0h1P+8eFgPLmddHxlo=";
			fetchSubmodules = true;
		};
		cargoDeps = rustPlatform.fetchCargoVendor {
			inherit pname version src;
			hash = "sha256-CLI54HSEOC/OVnIf0FmizVrS0adfzukFFBDl+EUP7BE=";
		};
		env.RUSTY_V8_ARCHIVE = fetchLibrustyV8 {
			version = "147.2.1";
			shas.x86_64-linux = "sha256-/oX8Aww6CwIsukfa/Rv/MYSXM3Ku8i19ID8UuXHQIvM=";
		};
	});
}
