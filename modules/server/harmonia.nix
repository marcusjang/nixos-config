{ config, ... }:
{
	sops.secrets."harmonia/key".mode = "0400";

	services.harmonia.enable = true;
	services.harmonia.signKeyPaths = [ config.sops.secrets."harmonia/key".path ];

	services.traefik.dynamicConfigOptions.http = {
		routers.harmonia = {
			rule = "Host(`nix-cache.dungeon.melange.works`)";
			entryPoints = "https";
			service = "harmonia";
			tls.certResolver = "cloudflare";
		};
		services.harmonia.loadbalancer.servers = [
			{ url = "http://localhost:5000"; }
		];
	};
}
