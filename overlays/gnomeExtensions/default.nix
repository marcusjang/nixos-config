final: prev: with final; {
	gnomeExtensions = prev.gnomeExtensions // {
		rounded-window-corners-reborn = unstable.gnomeExtensions.rounded-window-corners-reborn;
		power-off-options-sourcebuild = import ./power-off-options { inherit final prev; };
		gnome-brightness-control = callPackage ./gnome-brightness-control {};
		quick-settings-tweaker = callPackage ./quick-settings-tweaker {};
	};
}
