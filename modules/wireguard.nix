{ lib, pkgs, config, ... }:
{
	sops.secrets."wireguard/wg0/privateKey".mode = "0400";
	sops.secrets."wireguard/wg0/presharedKey".mode = "0400";

	environment.systemPackages = with pkgs; [
		wireguard-tools
	];

	networking.firewall = {
		allowedUDPPorts = [ 13231 51820 ];
	};

	networking.wg-quick.interfaces = {
		wg0 = {
			address = [ "10.0.30.4/32" ];
			listenPort = 51820;
			dns = [ "192.168.0.1" ];
			privateKeyFile = config.sops.secrets."wireguard/wg0/privateKey".path;
			peers = [
				{
					publicKey = "FRPOCws5AewREN8NhXuIkY+zC0/hJpsXe/VwM8+Jimk=";
					allowedIPs = [ "0.0.0.0/0" ];
					endpoint = "dungeon.melange.works:13231";
					persistentKeepalive = 25;
					presharedKeyFile = config.sops.secrets."wireguard/wg0/presharedKey".path;
				}
			];
		};
	};
	systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [ ];

	security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") == "wg-quick-wg0.service")
        { return polkit.Result.YES; }
      });
    '';
}
