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
	wrapGAppsHook3,
	openssl,
	libayatana-appindicator,
	jq,
}:
rustPlatform.buildRustPackage (finalAttrs: {
	pname = "hop";
	version = "0.3.1";

	src = fetchFromGitHub {
		owner = "golbin";
		repo = "hop";
		tag = "v${finalAttrs.version}";
		hash = "sha256-Yb7zDJ6A1Upm46a5gMFji7PRWTWyFA7qAX46RIiQ+i4=";
		fetchSubmodules = true;
	};

	pnpmDeps = fetchPnpmDeps {
		inherit (finalAttrs) pname version src;
		fetcherVersion = 3;
		hash = "sha256-0eQX3xvjQkAxPlTgqGJud+n9ASNEBWw+IcuIMbpi/so=";
	};

	cargoRoot = "apps/desktop/src-tauri";
	cargoHash = "sha256-B+Jir/M61adSOxaIUNb8spcch5jtOSV6YoQ+8mfSYQU=";
	buildAndTestSubdir = finalAttrs.cargoRoot;

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
	]
	++ lib.optionals stdenv.hostPlatform.isLinux [
		wrapGAppsHook3
	];

	buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
		glib-networking
		webkitgtk_4_1
		openssl
		libayatana-appindicator
	];

	# disable updater
	postPatch = ''
		TAURI_ROOT=${finalAttrs.cargoRoot}
		mv $TAURI_ROOT/tauri.conf.json $TAURI_ROOT/tauri.conf.json.old
		jq '.plugins.updater.endpoints = [ ] | .bundle.createUpdaterArtifacts = false' $TAURI_ROOT/tauri.conf.json.old > $TAURI_ROOT/tauri.conf.json
		rm $TAURI_ROOT/tauri.conf.json.old
	'' + lib.optionalString stdenv.hostPlatform.isLinux ''
		substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
			--replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
	'';

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
