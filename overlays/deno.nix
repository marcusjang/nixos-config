final: prev: with final; {
	deno = prev.unstable.deno.overrideAttrs (finalAttrs: prevAttrs: rec {
		inherit (prevAttrs) pname;
		version = "2.9.0";
		src = fetchFromGitHub {
			owner = "denoland";
			repo = "deno";
			tag = "v${version}";
			hash = "sha256-OthdQVFUzNpkVf/YWafbqeOTQhSjQ/NrxIs7HHpiTo8=";
			fetchSubmodules = true;
		};
		cargoDeps = rustPlatform.fetchCargoVendor {
			inherit (finalAttrs) pname version src;
			hash = "sha256-AWcLYRuckAyYagGKN6rSJSXpnD+tp8juRpW5MKLoz1Q=";
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
