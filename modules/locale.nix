{ ... }:
{
	i18n = {
		defaultLocale = "ko_KR.UTF-8";
		supportedLocales = [ "ko_KR.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
	};
	programs.dconf.profiles.user.databases = [{
		settings = {
			"org/gnome/system/locale" = {
				region = "ko_KR.UTF-8";
			};
		};
	}];
}
