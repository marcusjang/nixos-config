{ pkgs, ... }:
{
	i18n.inputMethod = {
		enable = true;
		type = "ibus";
		ibus.engines = [ pkgs.kime ];
		#type = "kime";
		#kime.iconColor = "White";
	};

	environment.systemPackages = [ pkgs.kime ];
}
