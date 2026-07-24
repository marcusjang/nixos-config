final: prev: with final; {
	deno = prev.unstable.deno.overrideAttrs (finalAttrs: prevAttrs: {
		inherit (prevAttrs) pname;
		version = "2.9.4";
		src = fetchFromGitHub {
			owner = "denoland";
			repo = "deno";
			tag = "v${finalAttrs.version}";
			hash = "sha256-ivch++yGRUyWtox/5QqomC4DlTvMBxK+gIcN9/7tt5E=";
			fetchSubmodules = true;
		};
		cargoDeps = rustPlatform.fetchCargoVendor {
			inherit (finalAttrs) pname version src;
			hash = "sha256-ynbHLZXkPPYpsC4dCu6jA6x8ftiTHWZ/uxzdbUcUaa0=";
		};
		env = prevAttrs.env // (let
			v8_version = (builtins.head (
				builtins.filter (pkg: pkg.name == "v8") (lib.importTOML "${finalAttrs.src}/Cargo.lock").package
			)).version;
		in {
			RUSTY_V8_ARCHIVE = prevAttrs.env.RUSTY_V8_ARCHIVE.overrideAttrs (finalAttrs: prevAttrs: {
				inherit (prevAttrs) pname;
				version = v8_version;
				src = fetchFromGitHub {
					owner = "denoland";
					repo = "rusty_v8";
					tag = "v${finalAttrs.version}";
					hash = "sha256-Iwgc08bUHR4OiwqopJua6fkQYMOdC5k9TgoCmZQrWIw=";
					fetchSubmodules = true;
				};
				cargoDeps = rustPlatform.fetchCargoVendor {
					inherit (finalAttrs) pname version src;
					hash = "sha256-M65ODvL+o3njO3SdbJaCvgRupoguCGCIoYY/dYiJPng=";
				};
				patches = prevAttrs.patches ++ [
					./patches/librusty_v8-gn-additional-outputs.patch
				];
			});
		});
	});
}
