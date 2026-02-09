pkgs: with pkgs; {
	gulim = callPackage ./gulim.nix { };
	gnome-shell-power-off-options-ko = callPackage ./gnome-shell-power-off-options-ko.nix { };
}
