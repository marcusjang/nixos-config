{ pkgs, outputs, ... }: 
{
	nixpkgs.config.allowUnfree = true;

	nixpkgs.overlays = [
		outputs.overlays.ghostty-flake
		outputs.overlays.legcord-icon
		outputs.overlays.legcord-latest
	];

	environment.systemPackages = with pkgs; [
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

	fonts = {
		enableDefaultPackages = true;
		packages = with pkgs; [
			pretendard
			nerd-fonts.meslo-lg
			noto-fonts
			noto-fonts-cjk-sans
			noto-fonts-cjk-serif
			hack-font
			fira-code
			nanum
		];
		fontconfig = {
			enable = true;
			defaultFonts = {
				sansSerif = [ "Pretendard" ];
			};
		};
	};
}
