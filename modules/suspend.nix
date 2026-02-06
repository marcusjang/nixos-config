{ ... }:
{
	services.power-profiles-daemon.enable = true;
	services.logind.settings.Login = {
		LidSwitch = "suspend-then-hibernate";
		PowerKey = "hibernate";
		PowerKeyLongPress = "poweroff";
	};

	boot.kernelParams = [ "mem_sleep_default=deep" ];

	systemd.sleep.extraConfig = ''
		HibernateDelaySec=30m
		SuspendState=mem
	'';
}
