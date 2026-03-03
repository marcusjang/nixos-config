{ config, inputs, ... }:
{
	nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

	sops.secrets."copyparty/accounts/marcus/password" = {
		mode = "0600";
		owner = config.services.copyparty.user;
		group = config.services.copyparty.group;
	};

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
			"/" = {
				path = "/share";
				access = {
					r = "*";
					rwmda = [ "marcus" ];
				};
			};
			"/archive" = { path = "/var/empty"; };
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
