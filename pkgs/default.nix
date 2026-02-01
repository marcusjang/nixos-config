pkgs: with pkgs; {
	tmux-ayu-theme = callPackage ./tmux-ayu-theme.nix { };
	gulim = callPackage ./gulim.nix { };
}
