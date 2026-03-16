{ config, ... }:
{
	sops.secrets."cloudflare/cert".mode = "0600";
	sops.secrets."cloudflare/tunnels/dungeon2".mode = "0600";

	services.cloudflared = {
		enable = true;
		certificateFile = config.sops.secrets."cloudflare/cert".path;
		tunnels = {
			"3d0c7157-ac7e-465c-9199-22090e657f49" = {
				credentialsFile = config.sops.secrets."cloudflare/tunnels/dungeon2".path;
				default = "http_status:404";
				ingress = {
					"dungeon2.melange.works" = {
						service = "http://localhost:${toString config.services.copyparty.settings.p}";
					};
				};
			};
		};
	};
}
