{
	sops.secrets."harmonia/pub".mode = "0400";
	nix.settings = {
		substituters = [ "https://nix-cache.dungeon.melange.works" ];
		trusted-public-keys = [ "nix-cache.dungeon.melange.works-1:JlaHA9DZ4qyt2nggs45O39i+C7hVtrcOxaex63rZghg=" ];
	};
}
