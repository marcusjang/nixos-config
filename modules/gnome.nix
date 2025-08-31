{ pkgs, ... }:
{
	services = {
		xserver = {
			enable = true;
			displayManager.gdm.enable = true;
			desktopManager.gnome.enable = true;
			excludePackages = [ pkgs.xterm ];
		};
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
			];
		};

		systemPackages = with pkgs.gnomeExtensions; [
			pkgs.gnome-color-manager
			pkgs.gnome-tweaks
			pkgs.pinentry-gnome3
			blur-my-shell
			dash-to-dock
			clipboard-indicator
			appindicator
			lockscreen-extension
			custom-command-toggle
			hibernate-status-button
			caffeine
			rounded-window-corners-reborn
			rounded-corners
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
