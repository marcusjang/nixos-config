{
	stdenv,
	fetchFromGitHub,
	glib,
}:
stdenv.mkDerivation (finalAttrs: {
	pname = "gnome-shell-extension-gnome-brightness-control";
	version = "unstable-260426";
	src = fetchFromGitHub {
		owner = "achirkin";
		repo = "gnome-brightness-control";
		rev = "8ca009e7b5acf7fe30b56c2c4d658a0478c60eb7";
		hash = "sha256-hx5bh5tYDwMeDqKHHAAs9IVngKqLLDzxQz+kwqyz5uw=";
	};
	passthru = {
		extensionUuid = "brightness-control@achirkin.noreply.users.github.com";
		extensionPortalSlug = "brightness-control";
	};
	nativeBuildInputs = [ glib ];
	buildPhase = ''
		runHook preBuild
		if [ -d schemas ]; then
			glib-compile-schemas --strict schemas
		fi
		runHook postBuild
	'';
	installPhase = ''
		runHook preInstall
		mkdir -p $out/share/gnome-shell/extensions
		cp -r -T . $out/share/gnome-shell/extensions/${finalAttrs.uuid}
		runHook postInstall
	'';
	doCheck = false;
	uuid = "brightness-control@achirkin.noreply.users.github.com";
})
