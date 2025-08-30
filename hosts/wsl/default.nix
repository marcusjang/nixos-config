{ inputs, outputs, ... }:
{
	imports =[
		outputs.nixosModules.default
		inputs.wsl.nixosModules.default
	];

	wsl = {
		enable = true;
		defaultUser = "marcus";
	};

	networking.hostName = "nixos-wsl";
	time.timeZone = "Asia/Seoul";

	system.stateVersion = "25.05";
}

