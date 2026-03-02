{ config, inputs, ... }:
{
	nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

	sops.secrets."copyparty/accounts/marcus/password".mode = "0600";

	services.copyparty = {
		enable = true;
		user = "copyparty";
		group = "nas";
		settings = {
			p = 3210;
			ftp = 14321;
			ftp-nat = "10.0.10.2";
			ftp-pr = "12000-12999";
		};
		accounts = {
			marcus.passwordFile = config.sops.secrets."copyparty/accounts/marcus/password".path;
		};
		volumes = {
			"/drive0" = {
				path = "/mnt/drive0/shared";
				access = {
					r = "*";
					rwmda = [ "marcus" ];
				};
			};
			"/drive1" = {
				path = "/mnt/drive1/shared";
				access = {
					r = "*";
					rwmda = [ "marcus" ];
				};
			};
			"/drive2" = {
				path = "/mnt/drive2/shared";
				access = {
					r = "*";
					rwmda = [ "marcus" ];
				};
			};
			"/drive3" = {
				path = "/mnt/drive3/shared";
				access = {
					r = "*";
					rwmda = [ "marcus" ];
				};
			};
		};
	};

	services.traefik.dynamicConfigOptions.http = {
		routers.copyparty = {
			rule = "Host(`copyparty.dungeon.melange.works`)";
			entryPoints = "https";
			service = "copyparty";
			tls.certResolver = "cloudflare";
		};
		services.copyparty.loadbalancer.servers = [
			{ url = "http://localhost:${toString config.services.copyparty.settings.p}"; }
		];
	};
}
