pkgs: with pkgs; {
	tmux-ayu-theme = callPackage ./tmux-ayu-theme.nix { };
	gulim = callPackage ./gulim.nix { };
	gnome-shell-power-off-options-ko = callPackage ./gnome-shell-power-off-options-ko.nix { };
}
