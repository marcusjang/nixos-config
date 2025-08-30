{ lib, pkgs, config, ... }:
{
	environment.systemPackages = with pkgs; [
		wireguard-tools
	];

	networking.firewall = {
		allowedUDPPorts = [ 13231 51820 ];
	};

	networking.wg-quick.interfaces = {
		wg0 = {
			address = [ "192.168.3.10/32" ];
			listenPort = 51820;
			dns = [ "192.168.1.1" ];
			privateKeyFile = config.sops.secrets."wireguard/wg0/privateKey".path;
			peers = [
				{
					publicKey = "IADPqQruIV4e5OUrY6U0gFjU7+0J7oOVtbDwdABym28=";
					allowedIPs = [ "0.0.0.0/0" ];
					endpoint = "dungeon.melange.works:13231";
					persistentKeepalive = 25;
				}
			];
		};
	};
	systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [ ];
}
