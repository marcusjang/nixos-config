pkgs: with pkgs; {
	tmux-ayu-theme = callPackage ./tmux-ayu-theme.nix { };
	cromite = callPackage ./cromite.nix { };
}
