{ lib, pkgs, ... }:
{
	i18n.inputMethod = {
		enable = true;
		type = "ibus";
		ibus.engines = [
			pkgs.kime
			pkgs.ibus-engines.hangul # fallback for unstable kime-ibus
		];
	};

	environment.systemPackages = [ pkgs.kime ];

	environment.variables = {
		GTK_IM_MODULE = lib.mkForce "kime";
		QT_IM_MODULE = lib.mkForce "kime";
		XMODIFIERS = lib.mkForce "@im=kime";
	};
}
