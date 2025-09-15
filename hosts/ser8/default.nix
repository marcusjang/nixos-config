{ pkgs, inputs, outputs, ... }:
{
	imports =[
		outputs.nixosModules.default
		inputs.hardware.nixosModules.common-cpu-amd
		inputs.hardware.nixosModules.common-cpu-amd-pstate
		inputs.hardware.nixosModules.common-cpu-amd-zenpower
		inputs.hardware.nixosModules.common-pc-ssd

		./hardware-configuration.nix
	];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.kernelPackages = pkgs.linuxPackages_latest;

	networking.hostName = "ser8";
	networking.networkmanager.enable = true;
	time.timeZone = "Asia/Seoul";

	system.stateVersion = "25.05";
}

