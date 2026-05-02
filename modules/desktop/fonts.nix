{ pkgs, ... }: 
{
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
			gulim
			batang
		];
		fontconfig = {
			enable = true;
			defaultFonts = {
				sansSerif = [ "Pretendard" ];
			};
		};
	};
}
