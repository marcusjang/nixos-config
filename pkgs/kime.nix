{
	lib,
	llvmPackages_18,
	rustPlatform,
	fetchFromGitHub,
	fetchpatch2,
	meson,
	ninja,
	cargo,
	rustc,
	pkg-config,
	dbus,
	libdbusmenu,
	libGL,
	wayland,
	libxkbcommon,
	python3,
	libxcb,
	cairo,
	gtk3,
	gtk4,
	qt6,
}:
llvmPackages_18.stdenv.mkDerivation (finalAttrs: {
	pname = "kime";
	version = "3.2.0";
	src = fetchFromGitHub {
		owner = "Riey";
		repo = "kime";
		rev = "v${finalAttrs.version}";
		hash = "sha256-AGjNo2LqAkpdfBtB3ytCizBa+gGRp7U+FyYHiyJDI8M=";
	};
	patches = [
		(fetchpatch2 {
			url = "https://github.com/Riey/kime/pull/751.patch";
			excludes = [
				"docs/CHANGELOG.md"
				"Cargo.lock"
			];
			hash = "sha256-3AqbUfP6JFLMbm1VnA4NTAx7r1Th+RYg2sDH3f8Crhs=";
		})
		./patches/kime-ibus-wayland-socket.patch
		./patches/kime-keycode-hotfix.patch
		./patches/kime-preedit-mode-hotfix.patch
	];
	cargoDeps = rustPlatform.fetchCargoVendor {
		inherit (finalAttrs) pname version src;
		hash = "sha256-opmOIGk6doCVr4VPPH+F9UVMGIkITlwHLjISLrneMzA=";
	};
	LIBCLANG_PATH = "${llvmPackages_18.libclang.lib}/lib";
	dontUseCmakeConfigure = true;
	dontWrapQtApps = true;
	buildInputs = [
		dbus
		libdbusmenu
		libGL
		wayland
		libxkbcommon
		libxcb
		cairo
		gtk3
		gtk4
		qt6.qtbase
	];
	nativeBuildInputs = [
		meson
		ninja
		rustPlatform.cargoSetupHook
		cargo
		rustc
		pkg-config
		python3
		llvmPackages_18.clang
		llvmPackages_18.libclang.lib
		llvmPackages_18.bintools
	];
	mesonFlags = [
		"-Dibus=enabled"
		"-Dqt5=disabled"
		"-Dqt6_plugindir=lib/qt-6/plugins"
	];
	postPatch = ''
		substituteInPlace res/ibus/component/kime.xml \
			--replace-fail "/usr/bin/kime-ibus" "$out/bin/kime-ibus"
	'';
	meta = {
		homepage = "https://github.com/Riey/kime";
		description = "Korean IME";
		license = lib.licenses.gpl3Plus;
		isIbusEngine = true;
		maintainers = [
			lib.maintainers.riey
			{
				email = "marcus@melange.works";
				github = "marcusjang";
				githubId = 10116562;
				name = "Marcus Jang";
			}
		];
		platforms = lib.platforms.linux;
	};
})
