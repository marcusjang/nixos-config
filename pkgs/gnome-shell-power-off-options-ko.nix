{ lib, stdenv, fetchFromGitHub, glib }:
stdenv.mkDerivation rec {
	name = "gnome-shell-power-off-options-ko-${version}";
	version = "7";

	src = fetchFromGitHub {
		owner = "marcusjang";
		repo = "power-off-options";
		rev = "6647560b184d4cbfa79c4e9245825f9608c0b013";
		hash = "sha256-XfRKjDrvvp9DvtEV6/VRr+c6aqWy8MnG3VfJoN56VT4=";
	};

	passthru = {
		extensionUuid = "power-off-options@axelitama.github.io";
		extensionPortalSlug = "power-off-options";
	};

	buildInputs = [ glib ];
	buildPhase = ''
		glib-compile-schemas --targetdir=${uuid}/schemas ${uuid}/schemas
		find "${uuid}/locale" -name '*.po' | while read -r po; do \
			mo="''${po%.po}.mo"; \
			msgfmt "$po" -o "$mo"; \
		done
	'';

	installPhase = ''
		runHook preInstall
		mkdir -p $out/share/gnome-shell/extensions
		cp -r ${uuid} $out/share/gnome-shell/extensions
		runHook postInstall
	'';

	uuid = "power-off-options@axelitama.github.io";
	meta = {
		description = "Adds extra options to the GNOME Power Off dialog such as 'Turn Off Screen', 'Hibernate', 'Hybrid Sleep', and now also custom commands!";
		license = lib.licenses.gpl2;
		maintainers = [ ];
		homepage = "https://github.com/marcusjang/power-off-options";
	};
}
