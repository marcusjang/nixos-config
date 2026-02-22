{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [
		libreoffice-fresh
		hunspell
		hunspellDicts.en_US
		hunspellDicts.en_GB-ise
		hunspellDicts.ko_KR
		hyphenDicts.en_US
		unstable.hyphenDicts.en_GB
	];
}
