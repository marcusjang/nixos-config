{
	lib,
	buildGoModule,
	fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
	pname = "tls-client";
	version = "1.15.1-nightly";

	src = fetchFromGitHub {
		owner = "bogdanfinn";
		repo = "tls-client";
		#tag = "v${finalAttrs.version}";
		rev = "b790a311273f26051935641120de169e497e5943";
		hash = "sha256-qYm48+wjdvZ21lAjAMGPKGVuA1K50sTnPM09+MK44BA=";
	};

	vendorHash = "sha256-ZvH9Ndnt5u/uH+4Q95rt54wN6yzKTOx9zld38e7Zg3E=";

	modRoot = "./cffi_dist";
	buildPhase = "go build -buildmode=c-shared -o $out/lib/tls-client.so";

	meta = {
		description = "net/http.Client like HTTP Client with options to select specific client TLS Fingerprints to use for requests.";
		homepage = "https://bogdanfinn.gitbook.io/open-source-oasis";
		downloadPage = "https://github.com/bogdanfinn/tls-client/releases";
		license = lib.licenses.bsdOriginal;
		maintainers = [ lib.importJSON ../maintainer.json ];
		platforms = [
			"x86_64-linux"
			"aarch64-linux"
		];
	};
})
