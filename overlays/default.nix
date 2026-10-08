{ inputs, ... }:
{
	additions = final: _prev: import ../pkgs final.pkgs;

	ghostty-flake = final: _prev: with final; {
		ghostty = inputs.ghostty.packages.${stdenv.hostPlatform.system}.default;
	};

	ghostty-patched = final: _prev: with final; {
		ghostty = prev.ghostty.overrideAttrs (finalAttrs: prevAttrs: {
			patches = [
			];
		});
	};

	unstable-packages = final: _prev: with final; {
		unstable = import inputs.nixpkgs-unstable {
			inherit (stdenv.hostPlatform) system;
			config.allowUnfree = true;
		};
	};

	nixpkgs-patched = final: _prev: with final; {
		patched = import (unstable.applyPatches {
			src = unstable.pkgs.path;
			patches = [
			];
		}) { inherit (stdenv.hostPlatform) system; };
	};

	cargo-tauri-latest = final: _prev: with final; {
		cargo-tauri = patched.cargo-tauri;
	};
	
	hop-older = final: prev: with final; {
		hop-older = prev.hop.overrideAttrs(finalAttrs: prevAttrs: {
			inherit (prevAttrs) pname;
			version = "0.4.4";
			src = fetchFromGitHub {
				owner = "golbin";
				repo = "hop";
				tag = "v${finalAttrs.version}";
				hash = "sha256-CM56MNKuHtQ1YThOtc5n9tgXCfSfjNSzwRTayrGXw/Q=";
				fetchSubmodules = true;
			};

			pnpmDeps = fetchPnpmDeps {
				inherit (finalAttrs) pname version src;
				fetcherVersion = 3;
				hash = "sha256-AhfjcFg/Iu+dyOJY8byrstK3h8QQ4BL/WWwqm1WHOxg=";
			};

			cargoDeps = rustPlatform.fetchCargoVendor {
				inherit (finalAttrs) pname version src cargoRoot;
				hash = "sha256-9jSX0O7tRFdTeDvxEY9xae+iWE2N5HNgiNA9DkVbmLI=";
			};
		});
	};

	gnomeExtensions-addon = import ./gnomeExtensions.nix;
	goofcord-latest = import ./goofcord.nix;
	deno-latest = import ./deno.nix;
	keepassxc-beta = import ./keepassxc.nix;
	libhangul-latest = import ./libhangul.nix;
	ibus-hangul-latest = import ./ibus-hangul.nix;
}
