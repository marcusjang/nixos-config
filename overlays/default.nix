{ inputs, ... }:
{
	additions = final: _prev: import ../pkgs final.pkgs;

	unstable-packages = final: _prev: {
		unstable = import inputs.nixpkgs-unstable {
			system = final.system;
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
	
	deno-latest = import ./deno.nix { inherit inputs; };
	cromite-latest = import ./cromite.nix { inherit inputs; };
}
