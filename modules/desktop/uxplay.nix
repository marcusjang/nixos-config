{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [
		uxplay
		unstable.gnomeExtensions.uxplay-control
	];

	services.avahi = {
		enable = true;
		nssmdns4 = true;
		nssmdns6 = true;
		publish = {
			enable = true;
			domain = true;
			userServices = true;
		};
	};

	networking.firewall.allowedTCPPorts = [ 28016 28017 28018 ];
	networking.firewall.allowedUDPPorts = [ 28016 28017 28018 ];
}

