{
	lib,
	buildGoModule,
	fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
	pname = "tls-client";
	version = "1.15.0";

	src = fetchFromGitHub {
		owner = "bogdanfinn";
		repo = "tls-client";
		tag = "v${finalAttrs.version}";
		hash = "sha256-Oisop/hEZLzrpoi5SXntLq5zeM14RvZ/LY8L3U08OHI=";
	};

	vendorHash = "sha256-wrU0GdxtvGmNOAlf4H36PKdL3MqrCG3XZIiGt0kjSbQ=";

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
