{ pkgs, ... }:
{
	services.xserver.enable = true;
	services.xserver.excludePackages = [ pkgs.xterm ];
	services.displayManager.gdm.enable = true;
	services.desktopManager.gnome.enable = true;

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

		systemPackages = with pkgs; [
			ffmpegthumbnailer
			gnome-color-manager
			gnome-session
			gnome-tweaks
			pinentry-gnome3
			switcheroo
		] ++ (with pkgs.gnomeExtensions; [
			# TEMP: until ko language PR is merged then updated on nixpkgs
			#power-off-options
			pkgs.gnome-shell-power-off-options-ko
			appindicator
			auto-move-windows
			blur-my-shell
			caffeine
			clipboard-indicator
			custom-command-toggle
			dash-to-dock
			lockscreen-extension
			no-overview
			quick-settings-tweaker
			rounded-corners
			rounded-window-corners-reborn
		]);
	};

	programs.dconf = {
		profiles.user.databases = [{
			settings = {
				"org/gnome/mutter" = {
					experimental-features = [
						"scale-monitor-framebuffer"
						"variable-refresh-rate"
						"xwayland-native-scaling"
					];
				};
			};
		}];
		profiles.gdm.databases = [{
			settings = {
				"org/gnome/login-screen" = {
					enable-fingerprint-authentication = false;
				};
			};
		}];
	};
}
