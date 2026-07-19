{
	lib,
	stdenv,
	fetchFromGitHub,
	meson,
	ninja,
	python313,
	gettext,
	pkg-config,
	wrapGAppsHook4,
	blueprint-compiler,
	desktop-file-utils,
	gobject-introspection,
	gtk4,
	libadwaita,
	glib,
	tinysparql,
	webkitgtk_6_0,
	libsoup_3,
	languagetool,
}: let
	pythonEnv = python313.withPackages (ps: with ps; [
		jinja2
		pygobject3
		lxml
		ebooklib
		beautifulsoup4
		pyyaml
		dulwich
	]);
in stdenv.mkDerivation (finalAttrs: {
	pname = "scriptorium";
	version = "1.3.0";

	src = fetchFromGitHub {
		owner = "cgueret";
		repo = "Scriptorium";
		tag = "v${finalAttrs.version}";
		hash = "sha256-IbxZm4irRtryS3Hsqtr2oUoCJ7Eg1y7jiHMu2uT2Sbo=";
	};

	postPatch = ''
		substituteInPlace scriptorium/language_tool.py \
			--replace-fail \
				'"/app/LanguageTool/languagetool-server.jar"' \
				'"${languagetool}/share/languagetool-server.jar"' \
			--replace-fail \
				'"java",' \
				'"${languagetool.jre}/bin/java",'
	'';

	nativeBuildInputs = [
		meson
		ninja
		gettext
		pkg-config
		wrapGAppsHook4
		blueprint-compiler
		desktop-file-utils
		gobject-introspection
		pythonEnv
	];

	buildInputs = [
		glib
		gtk4
		libadwaita
		tinysparql
		webkitgtk_6_0
		libsoup_3
		pythonEnv
	];

	meta = {
		description = "Scriptorium is a text editor coupled with a plotting tool and a formatting tool. The objective is to provide writers with a simple and complete environment to plan, plot, write and edit e-books.";
		homepage = "https://github.com/cgueret/Scriptorium";
		downloadPage = "https://github.com/cgueret/Scriptorium/releases";
		license = lib.licenses.gpl3;
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
		mainProgram = "scriptorium";
	};
})
