{ ... }:
{
	services.openssh = {
		enable = true;
		settings = {
			X11Forwarding = true;
			PermitRootLogin = "no";
			PasswordAuthentication = false;
		};
		openFirewall = true;
	};

	programs.mosh.enable = true;

	users.users."marcus".openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAQGnfAf5qxzSiPE3FhMqxF717jDLlblI0fCXlaL2le" # marcus@keepass
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAgTPArpqWPIxGVRwP+Ap2TN7hbUUtnGyP1pV8hn8dX/" # marcus@desktop
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILd/G7nepYED8JCi0h6kuLvSufSo+j0MSwVWSXFvsnmo" # marcus@ser8
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP/irMQq9qNQSTjt0FINPLQy/ZKHZ0fZkKOEIu5m4rrt" # marcus@mbp
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPsJMdW95Bl0/0E7JLp88EdTKXDV4ecMt5eZyzybp5ZL" # marcus@minibook
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGk+1j6U3UCAGc4C4pKAlqy7TkVFGtFcme9o6mdeg0QP" # marcus@iPhone via iSH
	];
}
