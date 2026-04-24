{ inputs, ... }:
{
	additions = final: _prev: import ../pkgs final.pkgs;

	ghostty-flake = final: _prev: with final; {
		ghostty = inputs.ghostty.packages.${stdenv.hostPlatform.system}.default;
		/*
		ghostty = inputs.ghostty.packages.${stdenv.hostPlatform.system}.default.overrideAttrs (finalAttrs: prevAttrs: {
			patches = [
			];
		});
		*/
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
				# goofcord: 1.7.1 -> 2.2.0
				(fetchpatch {
					url = "https://github.com/NixOS/nixpkgs/pull/487177.patch";
					hash = "sha256-/ySLGcHdBIEWS1tjfPuZLtqBbyKtJiQzD2HNIez7I6U=";
				})
			];
		}) { inherit (stdenv.hostPlatform) system; };
	};

	goofcord-icon = final: prev: with final; {
		goofcord = prev.patched.goofcord.overrideAttrs (prevAttrs: {
			nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ pkgs.jq ];
            postPatch = ''
                mv ./package.json ./package.json.old
                jq '.desktopName = "GoofCord"' ./package.json.old > ./package.json
                rm ./package.json.old
            '';

			desktopItems = [
				((builtins.elemAt prevAttrs.desktopItems 0).override { icon = "discord"; })
			];
		});
	};
	
	deno-latest = import ./deno.nix;
	libhangul-latest = import ./libhangul.nix;
	ibus-hangul-latest = import ./ibus-hangul.nix;
}
