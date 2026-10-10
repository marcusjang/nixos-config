{ final, prev }: with final; (
	prev.gnomeExtensions.power-off-options.overrideAttrs (finalAttrs: prevAttrs: {
		inherit (prevAttrs) pname;
		version = "8-dev";
		src = fetchFromGitHub {
			owner = "axelitama";
			repo = "power-off-options";
			rev = "8a9d10ea4e4bdade095ea26f3bfd9c2087d65435";
			hash = "sha256-W7XRnKoY0tQkPXq8Paoud5HUMOlHLuahVtFyc2KIRyI=";
		};
		passthru = {
			extensionUuid = "power-off-options@axelitama.github.io";
			extensionPortalSlug = "power-off-options";
		};
		nativeBuildInputs = [ final.pkgs.glib ];
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
)
