final: prev: with final; {
	keepassxc = prev.unstable.keepassxc.overrideAttrs (finalAttrs: prevAttrs: {
		inherit (prevAttrs) pname;
		version = "2.8.0-beta1";

		src = fetchFromGitHub {
			owner = "keepassxreboot";
			repo = "keepassxc";
			tag = finalAttrs.version;
			hash = "sha256-fksThYmGZed66zxGDxlS2SHQzJYRf+T9AuZPbaNZV5Y=";
		};

		patches = (lib.filter (patch:
			lib.baseNameOf patch != "darwin-remove-macdeployqt.patch"
		) prevAttrs.patches);

		cmakeFlags = (lib.filter (flag:
			flag != "-DKEEPASSXC_BUILD_TYPE:STRING=Release"
		) prevAttrs.cmakeFlags) ++ [
			(lib.cmakeFeature "KEEPASSXC_BUILD_TYPE" "Snapshot")
		];

		checkPhase = lib.replaceStrings [
			"${libsForQt5.qtbase.bin}"
			"${libsForQt5.qtbase.qtPluginPrefix}"
		] [
			"${qt6Packages.qtbase.bin}"
			"${qt6Packages.qtbase.qtPluginPrefix}"
		] prevAttrs.checkPhase;

		nativeBuildInputs = (lib.filter (drv:
			drv.pname != "qttools" &&
			drv.pname != "wrap-qt5-apps-hook"
		) prevAttrs.nativeBuildInputs) ++ (with pkgs; [
			qt6Packages.wrapQtAppsHook
			qt6Packages.qttools
		]);

		buildInputs = (lib.filter (drv:
			drv.pname != "qtbase" &&
			drv.pname != "qtsvg" &&
			drv.pname != "qtmacextras" &&
			drv.pname != "qtx11extras"
		) prevAttrs.buildInputs) ++ (with pkgs; [
			keyutils
			qt6Packages.qtbase
			qt6Packages.qtsvg
		]);
	});
}
