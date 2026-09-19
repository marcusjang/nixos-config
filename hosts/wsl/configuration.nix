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

	boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
	wsl.interop.register = true;

	networking.hostName = "wsl";
	time.timeZone = "Asia/Seoul";

	system.stateVersion = "25.05";
}

