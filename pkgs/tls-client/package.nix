{
	lib,
	buildGo127Module,
	fetchFromGitHub,
}:
buildGo127Module (finalAttrs: {
	pname = "tls-client";
	version = "1.18.1";

	src = fetchFromGitHub {
		owner = "bogdanfinn";
		repo = "tls-client";
		tag = "v${finalAttrs.version}";
		hash = "sha256-BgEkQkBkX/WmIN6hrcsW/HqHt7Qi7MMOc1LKxDMlYMk=";
	};

	vendorHash = "sha256-nqcYq3XwQJdEY/i3GMzFd0Qkr7AMZvzBKb4oTrWF5YI=";

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
