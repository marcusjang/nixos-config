{ ... }:
final: prev: {
	cromite = prev.cromite.overrideAttrs (old: rec {
		version = "139.0.7258.143";
		commit = "8b0ce0bcfdca08fb2ebb937d31c80d68488343f8";
		src = final.pkgs.fetchurl {
			url = "https://github.com/uazo/cromite/releases/download/v${version}-${commit}/chrome-lin64.tar.gz";
			hash = "sha256-jDjDXQLcQMD8PGw3GvieJer08WyIo8idhKo6oC0O/Nw=";
		};
	});
}
