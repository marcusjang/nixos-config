{ lib, pkgs, outputs, ... }:
{
	nixpkgs.overlays = with outputs.overlays; [
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
	environment.sessionVariables."IBUS_USE_PORTAL" = "1";

	programs.dconf = {
		profiles.user.databases = [{
			settings = {
				"desktop/ibus/engine/hangul" = {
					"word-commit" = false;
					"use-system-keyboard-layout" = true;
					"hanja-keys" = "Hangul_Hanja";
					"initial-input-mode" = "latin";
				};
			};
		}];
	};
}
