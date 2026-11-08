{ pkgs, outputs, ... }: 
{
	nix.settings.accept-flake-config = true;
	
	nixpkgs.config.allowUnfree = true;

	nixpkgs.overlays = with outputs.overlays; [
		ghostty-flake
		goofcord-latest
	];

	environment.systemPackages = with pkgs; [
		apostrophe
		celluloid
		discord
		firefox
		ghostty
		ibus
		keepassxc
		goofcord
		mpv
		thunderbird
		remmina
		winbox
		xdg-desktop-portal-gtk
		xprop
		yacreader
	];
}
