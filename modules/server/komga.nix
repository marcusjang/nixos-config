{ config, ... }:
{
	services.komga.enable = true;
	services.komga.settings.server.port = 8881;
	services.komga.group = "nas";

	services.traefik.dynamicConfigOptions.http = {
		routers.komga = {
			rule = "Host(`komga.dungeon.melange.works`)";
			entryPoints = "https";
			service = "komga";
			tls.certResolver = "cloudflare";
		};
		services.komga.loadbalancer.servers = [
			{ url = "http://localhost:${toString config.services.komga.settings.server.port}"; }
		];
	};
}
