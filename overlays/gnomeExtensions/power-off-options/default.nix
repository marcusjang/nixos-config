{
	stdenv,
	fetchFromGitHub,
	glib,
}:
stdenv.mkDerivation (finalAttrs: {
	pname = "gnome-shell-extension-power-off-options";
	version = "8-dev-260912";

	src = fetchFromGitHub {
		owner = "axelitama";
		repo = "power-off-options";
		rev = "44a10df7d7320666d085533c3027dbf7bb0b6bce";
		hash = "sha256-9UEmXb4EvPquxMZwZGHUPo1BbUq3QHG+OX2zs9nkh7U=";
	};

	passthru = {
		extensionUuid = "power-off-options@axelitama.github.io";
		extensionPortalSlug = "power-off-options";
	};

	nativeBuildInputs = [ glib ];

	buildPhase = with finalAttrs; ''
		glib-compile-schemas --targetdir=${uuid}/schemas ${uuid}/schemas
		find "${uuid}/locale" -name '*.po' | while read -r po; do \
			mo="''${po%.po}.mo"; \
			msgfmt "$po" -o "$mo"; \
		done
	'';

	installPhase = with finalAttrs; ''
		runHook preInstall
		mkdir -p $out/share/gnome-shell/extensions
		cp -r ${uuid} $out/share/gnome-shell/extensions
		runHook postInstall
	'';

	uuid = "power-off-options@axelitama.github.io";
})
