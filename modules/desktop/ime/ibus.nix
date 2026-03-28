{ pkgs, outputs, ... }:
{
	nixpkgs.overlays = [
		outputs.overlays.libhangul-latest
	];

	i18n = {
		inputMethod = {
			enable = true;
			type = "ibus";
			ibus.engines = with pkgs.ibus-engines; [ hangul ];
		};
	};
}
