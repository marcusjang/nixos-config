{
	stdenv,
	fetchFromGitLab,
}:
stdenv.mkDerivation (finalAttrs: {
	pname = "gnome-shell-extension-sleep-through-notifications";

	version = "unstable-240404-patched-261107";
	src = fetchFromGitLab {
		domain = "gitlab.gnome.org";
		owner = "rhendric";
		repo = "sleep-through-notifications";
		rev = "94a4dbcad8957998c15b90aeddbafadb694c4f0b";
		hash = "sha256-Wj/H8/nTB4x5pqWzudzazpNClgBfS4t4iPNQzH780l4=";
	};

	passthru = {
		extensionUuid = "sleep-through-notifications@rhendric.gitlab.the_name_of_this_desktop_environment.org";
		extensionPortalSlug = "sleep-through-notifications";
	};

	patches = [ ./patches/gnome-versions.patch ];

	installPhase = ''
		runHook preInstall
		mkdir -p $out/share/gnome-shell/extensions
		cp -r -T . $out/share/gnome-shell/extensions/${finalAttrs.uuid}
		runHook postInstall
	'';

	doCheck = false;
	uuid = "sleep-through-notifications@rhendric.gitlab.the_name_of_this_desktop_environment.org";
})
