{ ... }:
{
	services.power-profiles-daemon.enable = true;
	services.logind.settings.Login = {
		LidSwitch = "suspend-then-hibernate";
		PowerKey = "hibernate";
		PowerKeyLongPress = "poweroff";
	};

	systemd.sleep.extraConfig = ''
        HibernateDelaySec=30m
    '';
}
