{ ... }:
{
	import = [ ../firewall.nix ];
	
	services.fail2ban.enable = true;
}
