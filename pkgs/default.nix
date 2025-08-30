pkgs: {
	tmux-ayu-theme = import ./tmux-ayu-theme.nix { inherit pkgs; };
	cromite = import ./cromite.nix { inherit pkgs; };
}
