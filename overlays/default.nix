{ inputs, ... }:
{
	additions = final: _prev: import ../pkgs final.pkgs;

	ghostty-flake = final: _prev: {
		ghostty = inputs.ghostty.packages.${final.pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (finalAttrs: prevAttrs: {
			patches = [
				(final.pkgs.fetchpatch {
					url = "https://github.com/ghostty-org/ghostty/pull/10459.patch";
					hash = "sha256-CJVIlKhBMD0ll52heWKFNE7I4jo7eTK1AKvmO2PbiiA=";
				})
			];
		});
	};

	unstable-packages = final: _prev: {
		unstable = import inputs.nixpkgs-unstable {
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
	
	legcord-latest = import ./legcord.nix { inherit inputs; };
}
