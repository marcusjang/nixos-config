{ pkgs, ... }:
{
	services = {
		xserver = {
			enable = true;
			excludePackages = [ pkgs.xterm ];
		};
		displayManager.gdm.enable = true;
		desktopManager.gnome.enable = true;
	};

	environment = {
		gnome = {
			excludePackages = with pkgs; [
				gnome-tour
				geary
				simple-scan
				yelp
				seahorse
				gnome-weather
				gnome-contacts
				gnome-clocks
				gnome-calendar
				gnome-maps
				gnome-connections
			];
		};

		systemPackages = with pkgs.gnomeExtensions; [
			pkgs.gnome-color-manager
			pkgs.gnome-tweaks
			pkgs.pinentry-gnome3
			pkgs.switcheroo
			pkgs.ffmpegthumbnailer
			blur-my-shell
			dash-to-dock
			clipboard-indicator
			appindicator
			lockscreen-extension
			custom-command-toggle
			power-off-options
			caffeine
			rounded-window-corners-reborn
			rounded-corners
			pkgs.unstable.gnomeExtensions.quick-settings-tweaker
		];
	};

	programs.dconf.profiles.user.databases = [
		{
			settings = {
				"org/gnome/mutter" = {
					experimental-features = [
						"scale-monitor-framebuffer"
						"variable-refresh-rate"
						"xwayland-native-scaling"
					];
				};
			};
		}
	];
}
