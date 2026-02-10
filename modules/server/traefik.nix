{ config, ... }:
{
	sops.secrets.traefikEnv.mode = "0400";

	services.traefik = {
		enable = true;
		environmentFiles = [ config.sops.secrets.traefikEnv.path ];

		staticConfigOptions = {
			log = {
				level = "INFO";
				filePath = "${config.services.traefik.dataDir}/traefik.log";
				format = "json";
			};

			api = {
				#insecure = true;
				dashboard = true;
			};

			certificatesResolvers.cloudflare.acme = {
				dnsChallenge.provider = "cloudflare";
				email = "marcus@melange.works";
				storage = "${config.services.traefik.dataDir}/acme.json";
			};

			entryPoints = {
				http = {
					address = ":80";
					asDefault = true;
					/*
					http.redirections.entryPoint = {
						to = "https";
						scheme = "https";
					};
					*/
				};

				https = {
					address = ":443";
					asDefault = true;
					http.tls.certResolver = "cloudflare";
				};
			};
		};

		dynamicConfigOptions.http = {
			routers.api = {
				rule = "Host(`traefik.dungeon.melange.works`)";
				entryPoints = "https";
				service = "api@internal";
				tls.certResolver = "cloudflare";
			};
		};

	};
}
