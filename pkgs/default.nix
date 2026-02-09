pkgs: with pkgs; {
	deno-bin = callPackage ./deno-bin.nix { };
	gnome-shell-power-off-options-ko = callPackage ./gnome-shell-power-off-options-ko.nix { };
	gulim = callPackage ./gulim.nix { };
}
