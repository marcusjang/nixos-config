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
	makeDesktopItem,
	copyDesktopItems,
}:
rustPlatform.buildRustPackage (finalAttrs: {
	pname = "hop";
	version = "0.1.9";

	src = fetchFromGitHub {
		owner = "golbin";
		repo = "hop";
		tag = "v${finalAttrs.version}";
		hash = "sha256-DHhGEfiMnBWi0Rg+aLkNipOUoXxnDfeyIr/YnrLObi4=";
		fetchSubmodules = true;
	};

	nativeBuildInputs = [
		pnpmConfigHook
		pnpm
		nodejs_24
		cargo-tauri.hook
		pkg-config
		copyDesktopItems
	];

	buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
		webkitgtk_4_1
	];

	pnpmDeps = fetchPnpmDeps {
		inherit (finalAttrs) pname version src;
		fetcherVersion = 3;
		hash = "sha256-KJaKlearllEe9ON+H9cuO4wEVpz05pBxzhPcpojnxtQ=";
	};

	passthru = {
		inherit (finalAttrs) pnpmDeps;
	};

	cargoRoot = "apps/desktop/src-tauri";
	cargoHash = "sha256-zdkOfl+g0iGGhIb5WbkFxTkWUpM/l8/MbDrHwKuowfg=";
	buildAndTestSubdir = finalAttrs.cargoRoot;

	installPhase = ''
		runHook preInstall

		mkdir -p "$out/share/lib/hop-desktop"
		install -Dm644 "assets/logo/logo-256.png" "$out/share/icons/hicolor/256x256/apps/hop-desktop.png"

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
		mainProgram = "hop";
	};
})
