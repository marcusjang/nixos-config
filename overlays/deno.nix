{ ... }:
final: prev: {
	deno = prev.deno.overrideAttrs (old: rec {
		pname = old.pname;
		version = "2.5.2";
		name = "${old.pname}-${version}";

		src = final.pkgs.fetchurl {
			url = "https://github.com/denoland/deno/releases/download/v${version}/deno-x86_64-unknown-linux-gnu.zip";
			hash = "sha256-Ug/UvC0YtQtqwuqLfQ9/ajVYjkEnVKCB6Mav1LFSZMQ=";
		};

		nativeBuildInputs = with final.pkgs; [
			autoPatchelfHook
			unzip
		];
		buildInputs = with final.pkgs; [
			stdenv.cc.cc.lib
			unzip
		];
		srcs = [ src ];

		sourceRoot = ".";
		unpackPhase = "unzip -u ${src}";
		patchPhase = ":";
		installPhase = ''
			mkdir -p "$out/bin"
			install -m755 -D deno $out/bin/deno
		'';
	});
}
