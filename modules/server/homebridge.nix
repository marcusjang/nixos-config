{ config, lib, pkgs, ... }: let
	marcus-desktop = "10.0.10.10";
	marcus-work-vm = "10.0.10.11";
in {
	sops.secrets = {
		"homebridge/sshKey" = {
			mode = "0400";
			owner = config.services.homebridge.user;
			group = config.services.homebridge.group;
		};
		"homebridge/sshKey_pub" = {
			mode = "0400";
			owner = config.services.homebridge.user;
			group = config.services.homebridge.group;
		};
	};

	services.homebridge = {
		enable = true;
		openFirewall = true;
		settings = {
			accessories = [
				{
					accessory = "NetworkDevice";
					model = "NetworkDevice";
					name = "marcus@desktop";
					host = marcus-desktop;
					broadcastAddress = "10.0.10.255";
					mac = "34:5A:60:15:20:B1";
					pingCommand = "${lib.getExe' pkgs.iputils "ping"} -c 1 ${marcus-desktop}";
					pingCommandTimeout = 1;
					pingTimeout = 1;
					pingInterval = 2;
					pingsToChange = 5;
					startCommandTimeout = 0;
					wakeGraceTime = 30;
					wakeCommandTimeout = 0;
					shutdownCommand = "${lib.getExe pkgs.openssh} -o StrictHostKeyChecking=no -i ${config.sops.secrets."homebridge/sshKey".path} marcus@${marcus-desktop} \"shutdown /h\"";
					shutdownGraceTime = 15;
					shutdownCommandTimeout = 5;
					logLevel = "Info";
					returnEarly = false;
				}
				{
					accessory = "NetworkDevice";
					model = "NetworkDevice";
					name = "marcus@work.vm";
					host = marcus-work-vm;
					pingCommand = "${lib.getExe' pkgs.iputils "ping"} -c 1 ${marcus-work-vm}";
					pingCommandTimeout = 1;
					pingTimeout = 1;
					pingInterval = 2;
					pingsToChange = 5;
					startCommand = "${lib.getExe pkgs.openssh} -o StrictHostKeyChecking=no -i ${config.sops.secrets."homebridge/sshKey".path} marcus@${marcus-desktop} \"pwsh -Command \\\"& { Start-VM -Name marcus@work.vm }\\\"\"";
					startCommandTimeout = 0;
					wakeGraceTime = 30;
					wakeCommandTimeout = 0;
					shutdownCommand = "${lib.getExe pkgs.openssh} -o StrictHostKeyChecking=no -i ${config.sops.secrets."homebridge/sshKey".path} marcus@${marcus-desktop} \"pwsh -Command \\\"& { Stop-VM -Name marcus@work.vm }\\\"\"";
					shutdownGraceTime = 15;
					shutdownCommandTimeout = 5;
					logLevel = "Info";
					returnEarly = false;
				}
			];
			platforms = [
				{
					name = "LG ThinQ";
					platform = "LGThinQ";
					thinq1 = false;
					country = "KR";
					language = "ko-KR";
					auth_mode = "token";
					refresh_interval = 60;
				}
			];
		};
	};

	services.traefik.dynamicConfigOptions.http = {
		routers.homebridge = {
			rule = "Host(`homebridge.dungeon.melange.works`)";
			entryPoints = "https";
			service = "homebridge";
			tls.certResolver = "cloudflare";
		};
		services.homebridge.loadbalancer.servers = [
			{ url = "http://localhost:${toString config.services.homebridge.uiSettings.port}"; }
		];
	};
}
