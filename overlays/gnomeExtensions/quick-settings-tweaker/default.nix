{
	stdenv,
	fetchFromGitHub,
	glib,
	typescript,
	dart-sass,
}:
stdenv.mkDerivation (finalAttrs: {
	pname = "gnome-shell-extension-quick-settings-tweaks";
	version = "2.2-offx1.1";

	src = fetchFromGitHub {
		owner = "jstockdale";
		repo = "quick-settings-tweaks";
		rev = "v${finalAttrs.version}";
		hash = "sha256-HEMkTgQ5ITkGzo++Hr2y6uBUPvWhKbAtcaPKrYu0a1U=";
	};

	passthru = {
		extensionUuid = "quick-settings-tweaks@offx1";
		extensionPortalSlug = "quick-settings-tweaks";
	};

	nativeBuildInputs = [
		glib
		typescript
		dart-sass
	];

	buildPhase = ''
		runHook preBuild
		mkdir -p target/out

		tsc --noCheck
		cp -r target/tsc/* target/out

		sass --no-source-map src/stylesheet.scss:target/out/stylesheet.css
		sed $'s/^  /\t/g' -i target/out/stylesheet.css

		if [ -d schemas ]; then
		glib-compile-schemas --strict schemas
		fi

		mkdir -p target/out/locale

		find "po" -name '*.po' | while read -r po; do \
		locale=`basename $po .po`;
		path="target/out/locale/$locale/LC_MESSAGES";
		mkdir -p $path;
		mo="$path/quick-settings-tweaks.mo"; \
		msgfmt "$po" -o "$mo"; \
		done

		cp metadata.json target/out
		cp -r schemas target/out
		cp -r media target/out

		runHook postBuild
	'';

	installPhase = ''
		runHook preInstall
		mkdir -p $out/share/gnome-shell/extensions
		cp -r -T target/out $out/share/gnome-shell/extensions/${finalAttrs.uuid}
		runHook postInstall
	'';

	doCheck = false;
	uuid = "quick-settings-tweaks@offx1";
})
