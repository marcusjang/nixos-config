{ ... }:
{
	services.power-profiles-daemon.enable = true;
	services.logind.settings.Login = {
		HandleLidSwitch = "suspend-then-hibernate";
		HandlePowerKey = "hibernate";
		HandlePowerKeyLongPress = "poweroff";
	};

	systemd.sleep.extraConfig = ''
        HibernateDelaySec=60m
    '';
}
