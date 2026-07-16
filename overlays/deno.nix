final: prev: with final; {
	deno = prev.unstable.deno.overrideAttrs (finalAttrs: prevAttrs: {
		inherit (prevAttrs) pname;
		version = "2.9.3";
		src = fetchFromGitHub {
			owner = "denoland";
			repo = "deno";
			tag = "v${finalAttrs.version}";
			hash = "sha256-XMHlWK+lhyn1KO1CSxcuM3KzTjYviVrRw+FUL74bBPc=";
			fetchSubmodules = true;
		};
		cargoDeps = rustPlatform.fetchCargoVendor {
			inherit (finalAttrs) pname version src;
			hash = "sha256-WZxyoD9WMnaLyD3/86R90KWC+9OA15fIMw8SjmovNHA=";
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
					hash = "sha256-n4dKtki9ov0lWBeLmMDI4Tpk8zQ8YYSf04QW6DTYisY=";
					fetchSubmodules = true;
				};
				cargoDeps = rustPlatform.fetchCargoVendor {
					inherit (finalAttrs) pname version src;
					hash = "sha256-bGqg/6sfBaF/JpObgXyP4Mh+4P9zfuzd454m4wjluGw=";
				};
			});
		});
	});
}
