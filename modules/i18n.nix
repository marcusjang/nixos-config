{ pkgs, ... }:
{
	 i18n = {
		defaultLocale = "ko_KR.UTF-8";
		supportedLocales = [ "ko_KR.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
		inputMethod = {
			enable = true;
			type = "ibus";
			ibus.engines = with pkgs.ibus-engines; [ hangul ];
		};
	};

	environment.sessionVariables = {
		GTK_IM_MODULE = "ibus";
		QT_IM_MODULE = "ibus";
		XMODIFIERS = "@im=ibus";
	};
}
