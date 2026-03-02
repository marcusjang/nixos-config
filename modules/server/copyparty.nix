{ pkgs, inputs, ... }:
{
	nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

	services.copyparty.enable = true;
}
