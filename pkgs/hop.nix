{
	lib,
	stdenv,
	rustPlatform,
	fetchFromGitHub,
	fetchPnpmDeps,
	pnpmConfigHook,
	pnpm,
	nodejs_24,
	cargo-tauri,
	pkg-config,
	webkitgtk_4_1,
	glib-networking,
	wrapGAppsHook4,
	openssl,
	librsvg,
	jq,
	makeDesktopItem,
	copyDesktopItems,
}:
rustPlatform.buildRustPackage (finalAttrs: {
	pname = "hop";
	version = "0.1.10";

	src = fetchFromGitHub {
		owner = "golbin";
		repo = "hop";
		tag = "v${finalAttrs.version}";
		hash = "sha256-IRf7nvJNjoe0MyVqFY3Cm37F7ftg+f6o4mS0VtY+wCM=";
		fetchSubmodules = true;
	};

	pnpmDeps = fetchPnpmDeps {
		inherit (finalAttrs) pname version src;
		fetcherVersion = 3;
		hash = "sha256-1TPzRtgKl1jtJc8ykDSsW22G9jeA5vXyFCwQY/Y/GaQ=";
	};

	cargoRoot = "apps/desktop/src-tauri";
	cargoHash = "sha256-NbD8Djgy/mYR0ESROm21/S5/XpTyOCbZHBzS14+z+NQ=";
	buildAndTestSubdir = finalAttrs.cargoRoot;

	doCheck = false;

	passthru = {
		inherit (finalAttrs) pnpmDeps;
	};

	nativeBuildInputs = [
		cargo-tauri.hook
		pkg-config
		pnpmConfigHook
		pnpm
		nodejs_24
		jq
		copyDesktopItems
	]
	++ lib.optionals stdenv.hostPlatform.isLinux [
		wrapGAppsHook4
	];

	buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
		glib-networking
		webkitgtk_4_1
		openssl
		librsvg
	];

	# disable updater
	postPatch = ''
		TAURI_ROOT=${finalAttrs.cargoRoot}
		mv $TAURI_ROOT/tauri.conf.json $TAURI_ROOT/tauri.conf.json.old
		jq '.plugins.updater.endpoints = [ ] | .bundle.createUpdaterArtifacts = false' $TAURI_ROOT/tauri.conf.json.old > $TAURI_ROOT/tauri.conf.json
		rm $TAURI_ROOT/tauri.conf.json.old
	'';

	installPhase = ''
		runHook preInstall

		mkdir -p "$out/share/lib/hop-desktop"
		for size in 16 32 48 128 256 300 512 1024; do
			install -Dm644 "assets/logo/logo-"$size".png" $out/share/icons/hicolor/"$size"x"$size"/apps/hop-desktop.png
		done

		mkdir -p "$out/bin"
		target_dir="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
		cp -r "$target_dir/hop-desktop" "$out/bin/hop-desktop"

		runHook postInstall
	'';

	desktopItems = [
		(makeDesktopItem {
			name = "hop-desktop";
			genericName = "Word Processor";
			desktopName = "Hop";
			exec = "hop-desktop %F";
			icon = "hop-desktop";
			comment = finalAttrs.meta.description;
			keywords = [
				"word"
				"hangul"
				"hwp"
			];
			categories = [
				"WordProcessor"
				"Office"
			];
			startupWMClass = "Hop";
			terminal = false;
		})
	];

	meta = {
		description = "HOP is Open HWP";
		homepage = "https://golbin.github.io/hop/";
		downloadPage = "https://github.com/golbin/hop/releases";
		license = lib.licenses.mit;
		maintainers = [
			{
				email = "marcus@melange.works";
				github = "marcusjang";
				githubId = 10116562;
				name = "Marcus Jang";
			}
		];
		platforms = [
			"x86_64-linux"
		];
		mainProgram = "hop-desktop";
	};
})
