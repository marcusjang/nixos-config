{ pkgs, outputs, ... }: 
{
	nixpkgs.config.allowUnfree = true;

	nixpkgs.overlays = [
		outputs.overlays.ghostty-flake
		outputs.overlays.legcord-icon
		outputs.overlays.legcord-latest
		outputs.overlays.goofcord-icon
	];

	environment.systemPackages = with pkgs; [
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
