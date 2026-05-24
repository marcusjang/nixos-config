{ ... }:
{
	services.power-profiles-daemon.enable = true;
	services.logind.settings.Login = {
		HandleLidSwitch = "suspend-then-hibernate";
		HandlePowerKey = "hibernate";
		HandlePowerKeyLongPress = "poweroff";
	};

	systemd.sleep.settings = {
		Sleep = {
			HibernateDelaySec = "60m";
		};
	};
}
