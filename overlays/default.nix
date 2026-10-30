{ inputs, ... }:
{
	additions = final: _prev: import ../pkgs final.pkgs;

	ghostty-flake = final: _prev: with final; {
		ghostty = inputs.ghostty.packages.${stdenv.hostPlatform.system}.default;
	};

	/*
	ghostty-patched = final: _prev: with final; {
		ghostty = prev.ghostty.overrideAttrs (finalAttrs: prevAttrs: {
			patches = [
			];
		});
	};
	*/

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
				# keepassxc: 2.7.12 -> 2.8.0 - #577117
				(fetchpatch2 {
					url = "https://github.com/NixOS/nixpkgs/pull/577117.patch";
					hash = "sha256-bmN7J6hayJIdEwTaaqVX1Q+LwyzsTpxtpVDtlVsvNAM=";
				})
			];
		}) { inherit (stdenv.hostPlatform) system; };
	};
	
	gnomeExtensions-addon = import ./gnomeExtensions;
	goofcord-latest = import ./goofcord-latest;
	deno-latest = import ./deno-latest;
	libhangul-latest = import ./libhangul-latest;
	ibus-hangul-latest = import ./ibus-hangul-latest;
}
