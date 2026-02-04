{ pkgs, inputs, outputs, ... }:
{
	imports = [
		outputs.nixosModules.default
		inputs.hardware.nixosModules.lenovo-thinkpad-x1-13th-gen

		./hardware-configuration.nix
	];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.kernelPackages = pkgs.linuxPackages_latest;

	networking.hostName = "x1c13";
	networking.networkmanager.enable = true;
	time.timeZone = "Asia/Seoul";

	system.stateVersion = "25.11";
}

