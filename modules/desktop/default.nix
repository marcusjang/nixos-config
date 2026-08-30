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
