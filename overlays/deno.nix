final: prev: with final; {
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
				hash = "sha256-HompYzilJ7AC+HXfJJcvPC3L0rQfdAOhMhir/7qDXG8=";
				fetchSubmodules = true;
			};
			cargoDeps = rustPlatform.fetchCargoVendor {
				inherit pname version src;
				hash = "sha256-2h/zATsNngMg0Tvu5oSSveQNfaVbwFbzHndmSyP4Ddo=";
			};
		});
	});
}
