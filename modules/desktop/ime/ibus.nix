{ lib, pkgs, outputs, ... }:
{
	nixpkgs.overlays = with outputs.overlays; [
		ibus-latest
		libhangul-latest
		ibus-hangul-latest
	];

	i18n = {
		inputMethod = {
			enable = true;
			type = "ibus";
			ibus.engines = with pkgs.ibus-engines; [ hangul ];
		};
	};

	environment.variables."GTK_IM_MODULE" = lib.mkForce "";
}
