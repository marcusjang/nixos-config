{ pkgs, ... }:
{
	networking.firewall.enable = true;
	networking.nftables.enable = true;

	environment.systemPackages = with pkgs; [
		nixos-firewall-tool
	];
}
