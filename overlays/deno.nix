final: prev: with final; {
	deno = prev.unstable.deno.overrideAttrs (finalAttrs: prevAttrs: {
		inherit (prevAttrs) pname;
		version = "2.9.6";
		src = fetchFromGitHub {
			owner = "denoland";
			repo = "deno";
			tag = "v${finalAttrs.version}";
			hash = "sha256-4X7IfQk9NJizhZKqH2EuDnSfk8axkKFyiZEv1FOfWTM=";
			fetchSubmodules = true;
		};
		cargoDeps = rustPlatform.fetchCargoVendor {
			inherit (finalAttrs) pname version src;
			hash = "sha256-EKRC+wqIos9O0GHaxjmb/ghyzV6oCi1qwhO2tjszWR4=";
		};
		cargoBuildFeatures = (prevAttrs.cargoBuildFeatures or []) ++ [ "v8" ];
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
					hash = "sha256-dzFIzoMgs5UmUcCnl2XiGBBjPnPuVhvT6JS56y+xvoo=";
					fetchSubmodules = true;
				};
				cargoDeps = rustPlatform.fetchCargoVendor {
					inherit (finalAttrs) pname version src;
					hash = "sha256-OSHGZLGO1UKf8HQVV9iH+XanCOJoc301UvoI8jXoygw=";
				};
			});
		});
	});
}
