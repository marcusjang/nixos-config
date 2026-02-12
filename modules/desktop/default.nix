{ pkgs, outputs, ... }: 
{
	nixpkgs.config.allowUnfree = true;

	nixpkgs.overlays = [
		outputs.overlays.ghostty-flake
		outputs.overlays.legcord-icon
		outputs.overlays.legcord-latest
	];

	environment.systemPackages = with pkgs; [
		xprop
		firefox
		thunderbird
		ghostty
		remmina
		discord
		legcord
		keepassxc
		ibus
		xdg-desktop-portal-gtk
		mpv
		eog
		yacreader
		unstable.winbox4
	];
}
