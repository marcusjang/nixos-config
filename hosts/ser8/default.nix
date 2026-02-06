{ pkgs, inputs, outputs, ... }:
{
	imports = [
		outputs.nixosModules.default
		inputs.hardware.nixosModules.common-cpu-amd
		inputs.hardware.nixosModules.common-cpu-amd-pstate
		inputs.hardware.nixosModules.common-cpu-amd-zenpower
		inputs.hardware.nixosModules.common-pc-ssd
		inputs.hardware.nixosModules.common-hidpi

		./hardware-configuration.nix
	];

	environment.systemPackages = with pkgs; [
		unstable.zmk-studio
	];

	boot.loader.systemd-boot.enable = true;
	boot.loader.systemd-boot.configurationLimit = 4;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.kernelPackages = pkgs.linuxPackages_latest;

	networking.hostName = "ser8";
	networking.networkmanager.enable = true;
	time.timeZone = "Asia/Seoul";

	system.stateVersion = "25.05";
}

