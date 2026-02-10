{ ... }: let
	port = 8090;
in {
	virtualisation.oci-containers.containers = {
		mylar3 = {
			image = "lscr.io/linuxserver/mylar3:nightly";
			ports = [ "127.0.0.1:${toString port}:8090" ];
			environment = {
				PUID = "1001";
				PGID = "1001";
			};
			volumes = [
				"/var/lib/mylar3/config:/config"
				"/mnt/drive3/shared/data/comics:/comics"
				"/mnt/drive3/shared/data/downloads:/downloads"
			];
		};
	};

	services.traefik.dynamicConfigOptions.http = {
		routers.mylar3 = {
			rule = "Host(`comics.dungeon.melange.works`)";
			entryPoints = "https";
			service = "mylar3";
			tls.certResolver = "cloudflare";
		};
		services.mylar3.loadbalancer.servers = [
			{ url = "http://localhost:${toString port}"; }
		];
	};
}
