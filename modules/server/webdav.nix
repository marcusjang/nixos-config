{ config, ... }:
let
	port = 6065;
in {
	sops.secrets.webdavEnv.mode = "0600";

	services.webdav = {
		enable = true;
		environmentFile = config.sops.secrets.webdavEnv.path;
		group = "nas";
		settings = {
			port = port;
			directory = "/mnt/drive3/shared/WebDAV/data";
			users = [
				{
					username = "{env}WEBDAV_USERNAME";
					password = "{env}WEBDAV_PASSWORD";
					permissions = "CRUD";
				}
			];
		};
	};

	services.traefik.dynamicConfigOptions.http = {
		routers.webdav = {
			rule = "Host(`webdav.dungeon.melange.works`)";
			entryPoints = "https";
			service = "webdav";
			tls.certResolver = "cloudflare";
		};
		services.webdav.loadbalancer.servers = [
			{ url = "http://localhost:${toString port}"; }
		];
	};
}
