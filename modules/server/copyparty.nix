{ config, inputs, ... }:
{
	nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

	sops.secrets."copyparty/accounts/copyparty/password" = {
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
			copyparty.passwordFile = config.sops.secrets."copyparty/accounts/copyparty/password".path;
		};
		volumes = {
			"/" = {
				path = "/share";
				access = {
					r = "*";
					A = [ "copyparty" ];
				};
				flags = {
					chmod_f = "664";
					chmod_d = "775";
				};
			};
			"/archive" = {
				path = "/var/empty";
				access = {
					r = "*";
				};
			};
		};
	};

	networking.firewall.allowedTCPPorts = [ 3923 14321 ];
	networking.firewall.allowedTCPPortRanges = [
		{ from = 12000; to = 12999; }
	];
	networking.firewall.allowedUDPPorts = [ 69 1900 3969 5353 ];

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
