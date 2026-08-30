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

	gnomeExtensions-addon = import ./gnomeExtensions.nix;
	goofcord-latest = import ./goofcord.nix;
	deno-latest = import ./deno.nix;
	libhangul-latest = import ./libhangul.nix;
	ibus-hangul-latest = import ./ibus-hangul.nix;
}
