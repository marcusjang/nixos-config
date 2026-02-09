pkgs: with pkgs; {
	gnome-shell-power-off-options-ko = callPackage ./gnome-shell-power-off-options-ko.nix { };
	gulim = callPackage ./gulim.nix { };
}
