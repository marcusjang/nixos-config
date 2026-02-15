{ pkgs, outputs, ... }: 
{
	nixpkgs.config.allowUnfree = true;

	nixpkgs.overlays = [
		outputs.overlays.ghostty-flake
		outputs.overlays.legcord-icon
		outputs.overlays.legcord-latest
	];

	environment.systemPackages = with pkgs; [
		discord
		eog
		firefox
		ghostty
		ibus
		keepassxc
		legcord
		mpv
		remmina
		thunderbird
		unstable.winbox4
		xdg-desktop-portal-gtk
		xprop
		yacreader
	];
}
