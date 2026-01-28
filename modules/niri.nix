{ pkgs, lib, ... }:
{
	security.polkit.enable = true; # polkit
	services.gnome.gnome-keyring.enable = true;

	programs = {
		niri.enable = true;
		dank-material-shell = {
			enable = true;
			dgop.package = pkgs.unstable.dgop;
		};
	};

	environment.systemPackages = with pkgs; [
		alacritty
		fuzzel
		rofi
		swaybg
		swayidle
		swaylock
		waybar
		xwayland-satellite
	];

	i18n.inputMethod = {
		type = lib.mkForce "kime";
		kime = {
			iconColor = "White";
		};
	};
}

