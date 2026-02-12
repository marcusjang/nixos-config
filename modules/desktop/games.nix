{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [
		openrct2
	];
}
