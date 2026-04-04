{ inputs, ... }:
{
	additions = final: _prev: import ../pkgs final.pkgs;

	ghostty-flake = final: _prev: {
		ghostty = inputs.ghostty.packages.${final.pkgs.stdenv.hostPlatform.system}.default;
		/*
		ghostty = inputs.ghostty.packages.${final.pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (finalAttrs: prevAttrs: {
			patches = [
			];
		});
		*/
	};

	unstable-packages = final: _prev: {
		unstable = import inputs.nixpkgs-unstable {
			system = final.stdenv.hostPlatform.system;
			config.allowUnfree = true;
		};
	};

	nixpkgs-patched = final: _prev: {
		patched = import (final.pkgs.applyPatches {
			src = final.pkgs.path;
			patches = [
				(final.pkgs.fetchpatch {
					url = "https://github.com/NixOS/nixpkgs/pull/490544.patch";
					hash = "sha256-TE0inT45HDkz0MIYzDFZdfUj70KrsR2eHG/6xQvfAw8=";
				})
			];
		}) {
			system = final.stdenv.hostPlatform.system;
			config.allowUnfree = true;
		};

	};

	legcord-icon = final: prev: {
		legcord = prev.legcord.overrideAttrs (old: {
			desktopItems = [
				((builtins.elemAt old.desktopItems 0).override { icon = "discord"; })
			];
		});
	};
	
	legcord-latest = import ./legcord.nix { };
	libhangul-latest = import ./libhangul.nix { };
	ibus-hangul-latest = import ./ibus-hangul.nix { };
}
