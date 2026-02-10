{ config, ... }:
{
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
