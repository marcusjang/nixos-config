{ pkgs, config, ... }: 
{
	programs.zsh.enable = true;
	users.users.marcus = {
		description = "Marcus";
		shell = pkgs.zsh;
		hashedPasswordFile = config.sops.secrets."user/marcus/password".path;
		isNormalUser = true;
		extraGroups = [ "networkmanager" "wheel" ];
		openssh.authorizedKeys.keys = [
		];
	};
}
