final: prev: with final; {
	deno = prev.unstable.deno.overrideAttrs (finalAttrs: prevAttrs: rec {
		inherit (prevAttrs) pname;
		version = "2.8.2";
		src = fetchFromGitHub {
			owner = "denoland";
			repo = "deno";
			tag = "v${version}";
			hash = "sha256-WtACDLrC1c7KxkoQgYrNavykkm8+tZmF46UU1YrLwVs=";
			fetchSubmodules = true;
		};
		cargoDeps = rustPlatform.fetchCargoVendor {
			inherit (finalAttrs) pname version src;
			hash = "sha256-Og+owcfHfdFJ08Xtiye2IEvKWd2Q/7f7QzQ/898IOcQ=";
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
					hash = "sha256-OAwfrSU1bu80+qcseUHtScVLZCTe9mY3NEfq0+hmVMg=";
					fetchSubmodules = true;
				};
				cargoDeps = rustPlatform.fetchCargoVendor {
					inherit (finalAttrs) pname version src;
					hash = "sha256-dkuvWJaDPmsU25f3UGifWl2GvYku6+7Htk9tm5JVpLU=";
				};
			});
		});
	});
}
