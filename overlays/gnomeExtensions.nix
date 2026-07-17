final: prev: let
	buildGnomeExtension = final.pkgs.callPackage "${final.pkgs.path}/pkgs/desktops/gnome/extensions/buildGnomeExtension.nix" { };
in with final; {
	gnomeExtensions = prev.gnomeExtensions // {
		power-off-options-sourcebuild = prev.gnomeExtensions.power-off-options.overrideAttrs (finalAttrs: prevAttrs: {
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
		});
		rounded-window-corners-reborn = with prev.gnomeExtensions.rounded-window-corners-reborn; buildGnomeExtension {
			uuid = extensionUuid;
			name = extensionPortalSlug;
			pname = "${name}-${version}";
			inherit (meta) description;
			link = meta.homepage;
			version = toString 18;
			sha256 = "sha256-sK9zY5iJereJpiUSPQHIcTfcy5i8wrpoM0h0o+LSzu0=";
			metadata = "ewoJICAiX2dlbmVyYXRlZCI6ICJHZW5lcmF0ZWQgYnkgU3dlZXRUb290aCwgZG8gbm90IGVkaXQiLAoJICAiZGVzY3JpcHRpb24iOiAiQWRkIHJvdW5kZWQgY29ybmVycyB0byBhbGwgd2luZG93cy4gRm9yayBvZiB0aGUgbm93IHVubWFpbnRhaW5lZCBSb3VuZGVkIFdpbmRvdyBDb3JuZXJzIGV4dGVuc2lvbi4iLAoJICAiZ2V0dGV4dC1kb21haW4iOiAicm91bmRlZC13aW5kb3ctY29ybmVyc0BmeGduIiwKCSAgIm5hbWUiOiAiUm91bmRlZCBXaW5kb3cgQ29ybmVycyBSZWJvcm4iLAoJICAic2V0dGluZ3Mtc2NoZW1hIjogIm9yZy5nbm9tZS5zaGVsbC5leHRlbnNpb25zLnJvdW5kZWQtd2luZG93LWNvcm5lcnMtcmVib3JuIiwKCSAgInNoZWxsLXZlcnNpb24iOiBbCgkgICAgIjQ5IiwKCSAgICAiNTAiCgkgIF0sCgkgICJ1cmwiOiAiaHR0cHM6Ly9naXRodWIuY29tL2ZsZXhhZ29vbi9yb3VuZGVkLXdpbmRvdy1jb3JuZXJzIiwKCSAgInV1aWQiOiAicm91bmRlZC13aW5kb3ctY29ybmVyc0BmeGduIiwKCSAgInZlcnNpb24iOiAxOAp9";
		};
		gnome-brightness-control = stdenv.mkDerivation (finalAttrs: {
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
			nativeBuildInputs = [ final.pkgs.glib ];
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
		});
		quick-settings-tweaker = stdenv.mkDerivation (finalAttrs: {
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
			nativeBuildInputs = with final.pkgs; [
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
		});
	};
}
