final: prev: with final; {
	deno = prev.unstable.deno.overrideAttrs (finalAttrs: prevAttrs: rec {
		inherit (prevAttrs) pname;
		version = "2.8.1";
		src = fetchFromGitHub {
			owner = "denoland";
			repo = "deno";
			tag = "v${version}";
			hash = "sha256-rWmOFKRoS5oPpI0qzJS0Z9w7S1fz+2W/2psT+lPSFfw=";
			fetchSubmodules = true;
		};
		cargoDeps = rustPlatform.fetchCargoVendor {
			inherit (finalAttrs) pname version src;
			hash = "sha256-JAFSL0wwIJDUQgXScIzgXtrBTwqCh7MPCpo+ecWWj6E=";
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
					hash = "sha256-OdVz8d8hkBhXZnX9vKV51rlHAYN2PbVycmqrDWNLV5M=";
					fetchSubmodules = true;
				};
				cargoDeps = rustPlatform.fetchCargoVendor {
					inherit (finalAttrs) pname version src;
					hash = "sha256-uj1B3lkgbZG5emJgfsilJXdHbqg0JNAywaSVLe/LbWk=";
				};
				patches = (builtins.filter (patch:
					!(builtins.typeOf patch == "set" && patch.name == "chromium-146-revert-Update-fsanitizer=array-bounds-config.patch") &&
					!(builtins.typeOf patch == "path" && baseNameOf patch == "librusty_v8_revert_-fno-lifetime-dse.patch")
				) prevAttrs.patches) ++ [
					./patches/librusty_v8_rust_toolchain_nix_path.patch
					./patches/librusty_v8_buildconfig.patch
				];
				env = prevAttrs.env // {
					GN = lib.getExe patched.gn;
					EXTRA_GN_ARGS = builtins.replaceStrings [
						" removed_rust_stdlib_libs=[\"adler\"]"
						" added_rust_stdlib_libs=[\"adler2\"]"
					] [ "" "" ] prevAttrs.env.EXTRA_GN_ARGS;
				};
			});
		});
	});
}
