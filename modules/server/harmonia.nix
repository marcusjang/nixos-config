{ inputs, config, ... }:
{
	imports = [ inputs.harmonia.nixosModules.harmonia ];

	sops.secrets.harmonia-key.mode = "0400";

	services.harmonia-dev = {
		cache.enable = true;
		cache.signKeyPaths = [ config.sops.secrets.harmonia-key.path ];
		cache.settings.priority = 30;
		daemon.enable = true;
	};

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
