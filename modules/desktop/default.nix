{ pkgs, outputs, ... }: 
{
	nixpkgs.config.allowUnfree = true;

	nixpkgs.overlays = with outputs.overlays; [
		ghostty-flake
		goofcord
	];

	environment.systemPackages = with pkgs; [
		celluloid
		discord
		eog
		firefox
		ghostty
		ibus
		keepassxc
		goofcord
		mpv
		thunderbird
		unstable.remmina
		unstable.winbox4
		xdg-desktop-portal-gtk
		xprop
		yacreader
	];
}
