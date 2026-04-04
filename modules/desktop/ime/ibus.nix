{ pkgs, outputs, ... }:
{
	nixpkgs.overlays = [
		outputs.overlays.libhangul-latest
		outputs.overlays.ibus-hangul-latest
	];

	i18n = {
		inputMethod = {
			enable = true;
			type = "ibus";
			ibus.engines = with pkgs.ibus-engines; [ hangul ];
		};
	};
}
