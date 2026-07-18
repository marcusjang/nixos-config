final: prev: with final; {
	udisks = prev.unstable.udisks.overrideAttrs(finalAttrs: prevAttrs: {
		version = "2.11.1-nightly";
		src = fetchFromGitHub {
			owner = "storaged-project";
			repo = "udisks";
			rev = "8a5802accf8f7d451d59fc5bec4b0b47cfdcfcc2";
			hash = "sha256-OkfRyFPpvKdBTGvzIQTrqs9Jj1YS11/D7PUkDNMxm08=";
		};
	});
}
