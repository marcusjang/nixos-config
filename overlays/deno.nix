final: prev: with final; {
	deno = prev.unstable.deno.overrideAttrs (finalAttrs: prevAttrs: rec {
		inherit (prevAttrs) pname;
		version = "2.7.14";
		src = fetchFromGitHub {
			owner = "denoland";
			repo = "deno";
			tag = "v${version}";
			hash = "sha256-tkZc89JOhXCdMVSAOQYGR6HDe7KmCI5/haLH1RP2p7I=";
			fetchSubmodules = true;
		};
		cargoDeps = rustPlatform.fetchCargoVendor {
			inherit (finalAttrs) pname version src;
			hash = "sha256-bFQLsAF4hFBRw04VaL+sxvxIZ9p7nXOLSr2BIZKcwiI=";
		};
		env.RUSTY_V8_ARCHIVE = let
			v8_version = (builtins.head (
				builtins.filter (pkg: pkg.name == "v8") (lib.importTOML "${src}/Cargo.lock").package
			)).version;
		in prev.unstable.deno.librusty_v8.overrideAttrs (finalAttrs: prevAttrs: rec {
			inherit (prevAttrs) pname;
			version = v8_version;
			src = fetchFromGitHub {
				owner = "denoland";
				repo = "rusty_v8";
				tag = "v${version}";
				hash = "sha256-cS9oBDY2+9RtdqPuOadNl0Lce89ESpBb1qPiWSHPiCg=";
				fetchSubmodules = true;
			};
			cargoDeps = rustPlatform.fetchCargoVendor {
				inherit (finalAttrs) pname version src;
				hash = "sha256-e/G9AevaJwqYdr8022kmv05Mwzi4Cishj9imLproNB0=";
			};
		});
	});
}
