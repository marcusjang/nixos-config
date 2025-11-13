{ pkgs, inputs, outputs, ... }: 
{
	nixpkgs.config.allowUnfree = true;

	nixpkgs.overlays = [
		outputs.overlays.zmk-studio
		outputs.overlays.legcord-icon
		outputs.overlays.legcord-latest
		outputs.overlays.cromite-latest
	];

	environment.systemPackages = with pkgs; [
		firefox
		ungoogled-chromium
		thunderbird
		birdtray
		inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
		remmina
		discord
		legcord
		keepassxc
		ibus
		home-manager
		xdg-desktop-portal-gtk
		mpv
		yacreader
		unstable.winbox4
		zmk-studio.zmk-studio
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
		];
		fontconfig = {
			enable = true;
			defaultFonts = {
				sansSerif = [ "Pretendard" ];
			};
		};
	};
}
