{ config, ... }: 
{
	users.users.git = {
		description = "GIT";
		isNormalUser = true;
		home = "/git";
		extraGroups = [ ];
		openssh.authorizedKeys.keys = config.users.users."marcus".openssh.authorizedKeys.keys;
	};
}

