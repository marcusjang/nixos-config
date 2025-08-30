{ pkgs }: let
	channel = import (pkgs.fetchFromGitHub {
		owner = "NixOS";
		repo = "nixpkgs";
		rev = "a91c10f29aa01ce3b4f28ff7eaea94d470a93ccb";
		hash = "sha256-1mshHPmomBJOAgcGcKuxWPFBM2MPAtPTD6K6gf+9uio=";
	}) { system = pkgs.system; };
in channel.cromite
