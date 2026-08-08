{ lib, pkgs, config, ... }: let
	ibusPackage = pkgs.ibus-with-plugins.override {
		plugins = with pkgs; [
			kime
			ibus-engines.hangul
		];
	};
in {
	i18n.inputMethod.enable = false;

	environment.systemPackages = [
		ibusPackage
		pkgs.kime
	];

    environment.etc."xdg/autostart/ibus-daemon.desktop".text = ''
        [Desktop Entry]
        Name=Ibus
        Type=Application
        Exec=${ibusPackage}/bin/ibus-daemon --daemonize --xim
        NotShowIn=GNOME;KDE;
    '';

    environment.etc."xdg/kime/config.yaml".text = ''
        daemon:
          modules: 
          - Xim
          - Wayland
          - Indicator
        indicator:
          icon_color: White
    '';

	environment.variables = {
		GTK_IM_MODULE = "kime";
		QT_IM_MODULE = "kime";
		XMODIFIERS = "@im=kime";
	};

	programs.dconf.enable = true;
	programs.dconf.packages = [ ibusPackage ];

	services.dbus.packages = [ ibusPackage ];

	xdg.portal.extraPortals = lib.mkIf config.xdg.portal.enable [ ibusPackage ];
}
