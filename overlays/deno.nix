final: prev: with final; {
	deno = prev.unstable.deno.overrideAttrs (finalAttrs: prevAttrs: rec {
		inherit (prevAttrs) pname;
		version = "2.9.2";
		src = fetchFromGitHub {
			owner = "denoland";
			repo = "deno";
			tag = "v${version}";
			hash = "sha256-MZ3GDqC54OYeSwg1tA9FQJrorZL/sc8KdABAkJ3RkoQ=";
			fetchSubmodules = true;
		};
		cargoDeps = rustPlatform.fetchCargoVendor {
			inherit (finalAttrs) pname version src;
			hash = "sha256-hyvjzQoeOUeH+OpfTyjMVmUTtBuQ5c57/qea8pUpZek=";
		};
		env = prevAttrs.env // (let
			v8_version = (builtins.head (
				builtins.filter (pkg: pkg.name == "v8") (lib.importTOML "${src}/Cargo.lock").package
			)).version;
		in {
			RUSTY_V8_ARCHIVE = prev.unstable.deno.librusty_v8.overrideAttrs (finalAttrs: prevAttrs: rec {
				inherit (prevAttrs) pname;
				version = v8_version;
				src = fetchFromGitHub {
					owner = "denoland";
					repo = "rusty_v8";
					tag = "v${version}";
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
