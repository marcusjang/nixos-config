{ inputs, ... }:
{
	additions = final: _prev: import ../pkgs final.pkgs;

	ghostty-flake = final: _prev: {
		ghostty = inputs.ghostty.packages.${final.pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (finalAttrs: prevAttrs: {
			patches = [
				(final.pkgs.fetchpatch {
					url = "https://github.com/ghostty-org/ghostty/pull/10459.patch";
					hash = "sha256-YmqiNE8nkRuzF793vJ+YRdpXe4V4EK9Lo4VAekORNJI=";
				})
				(final.pkgs.fetchpatch {
					url = "https://github.com/ghostty-org/ghostty/pull/10809.patch";
					hash = "sha256-dgS+fbE5+8tgy0huNoCTx22E/woxuzIC303bzps7TRM=";
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
	
	legcord-latest = import ./legcord.nix { };
}
