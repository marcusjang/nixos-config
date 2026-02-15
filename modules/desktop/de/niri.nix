{ pkgs, ... }:
{
	services.displayManager.dms-greeter.enable = true; 
	services.displayManager.dms-greeter.compositor.name = "niri";

	programs.niri.enable = true;

	programs.dms-shell.enable = true;

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
}

