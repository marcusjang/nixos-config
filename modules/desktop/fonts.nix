{ pkgs, ... }: 
{
	fonts = {
		enableDefaultPackages = true;
		packages = (with pkgs; [
			pretendard
			noto-fonts
			noto-fonts-cjk-sans
			noto-fonts-cjk-serif
			hack-font
			fira-code
			nanum
			gulim
			batang
		]) ++ (with pkgs.nerd-fonts; [
			agave
			caskaydia-cove
			d2coding
			meslo-lg
		]);
		fontconfig = {
			enable = true;
			defaultFonts = {
				sansSerif = [ "Pretendard" ];
				monospace = [
					"MesloLGS Nerd Font"
					"D2CodingLigature Nerd Font"
				];
			};
		};
	};
}
