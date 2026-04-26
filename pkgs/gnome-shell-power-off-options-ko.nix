{ lib, stdenv, fetchFromGitHub, glib }:
stdenv.mkDerivation rec {
	name = "gnome-shell-power-off-options-ko-${version}";
	version = "7";

	src = fetchFromGitHub {
		owner = "axelitama";
		repo = "power-off-options";
		rev = "10680913ff3de4d2fa519c0ffbd7cd3b01734fd6";
		hash = "sha256-W64zSRpFX+5SZou7N+FAeQZ0T9Bk/qzXhgr+TuEP4T4=";
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
		maintainers = [
			{
				email = "marcus@melange.works";
				github = "marcusjang";
				githubId = 10116562;
				name = "Marcus Jang";
			}
		];
		homepage = "https://github.com/marcusjang/power-off-options";
	};
}
