{
	lib,
	buildGoModule,
	fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
	pname = "tls-client";
	version = "1.15.1";

	src = fetchFromGitHub {
		owner = "bogdanfinn";
		repo = "tls-client";
		tag = "v${finalAttrs.version}";
		hash = "sha256-m64nDlPwRWNEfb4dQV6gxwhe80/zcgnfruhQkZoShqc=";
	};

	vendorHash = "sha256-CifciilXj7tFKbHSux+mKnLAWYxBqBWS1ngIo6V92Nw=";

	modRoot = "./cffi_dist";
	buildPhase = "go build -buildmode=c-shared -o $out/lib/tls-client.so";

	meta = {
		description = "net/http.Client like HTTP Client with options to select specific client TLS Fingerprints to use for requests.";
		homepage = "https://bogdanfinn.gitbook.io/open-source-oasis";
		downloadPage = "https://github.com/bogdanfinn/tls-client/releases";
		license = lib.licenses.bsdOriginal;
		maintainers = [
			{
				email = "marcus@melange.works";
				github = "marcusjang";
				githubId = 10116562;
				name = "Marcus Jang";
			}
		];
		platforms = [
			"x86_64-linux"
		];
	};
})
