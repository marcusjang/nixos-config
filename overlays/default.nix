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
			system = stdenv.hostPlatform.system;
			config.allowUnfree = true;
		};
	};

	nixpkgs-patched = final: _prev: with final; {
		patched = import (applyPatches {
			src = pkgs.path;
			patches = [
				# goofcord: fetcherVersion = 1 to 3
				(fetchpatch {
					url = "https://github.com/NixOS/nixpkgs/commit/fb7791755e14f21b6afcbf74624b5043d93b3dac.patch";
					hash = "sha256-6QFs0xR5jEMJuWMw/P/94U0R//n5KhMZ8zzCgTSN3a8=";
				})
				# goofcord: 1.7.1 -> 2.2.0
				(fetchpatch {
					url = "https://github.com/NixOS/nixpkgs/pull/487177.patch";
					hash = "sha256-2550UNgJM6Rt0QZ8GmeT7c2uElAyjxkEpB5WlkhO3Qw=";
				})
			];
		}) {
			system = stdenv.hostPlatform.system;
			config.allowUnfree = true;
		};

	};

	legcord-icon = _final: prev: {
		legcord = prev.legcord.overrideAttrs (prevAttrs: {
			desktopItems = [
				((builtins.elemAt prevAttrs.desktopItems 0).override { icon = "discord"; })
			];
		});
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
	
	legcord-latest = import ./legcord.nix;
	deno-latest = import ./deno.nix;
	libhangul-latest = import ./libhangul.nix;
	ibus-hangul-latest = import ./ibus-hangul.nix;
}
