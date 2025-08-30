{ pkgs ? import <nixpkgs> }:
with pkgs; tmuxPlugins.mkTmuxPlugin {
	pluginName = "tmux-ayu-theme";
	rtpFilePath = "tmux-ayu-theme.tmux";
	version = "1.0.0";
	src = fetchFromGitHub {
		owner = "TechnicalDC";
		repo = "tmux-ayu-theme";
		rev = "2ddd8537e2f98cc760c1e2ded4bcbc62a20b8f42";
		sha256 = "1bcamp3hbavb3wrkv8c0rrx683kdz0nvpsy9alzj9h9rs79czhpw";
	};
}
