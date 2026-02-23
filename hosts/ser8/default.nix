{ pkgs, inputs, outputs, ... }:
{
	imports = [
		outputs.nixosModules.default
		inputs.hardware.nixosModules.common-cpu-amd
		inputs.hardware.nixosModules.common-cpu-amd-pstate
		inputs.hardware.nixosModules.common-cpu-amd-zenpower
		inputs.hardware.nixosModules.common-gpu-amd
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

	boot.kernelParams = [
		"resume_offset=128559104"
		"mem_sleep_default=s2idle"
	];
	boot.resumeDevice = "/dev/disk/by-uuid/311cc798-4f3a-4211-b196-564c5960a612";

	powerManagement.enable = true;

	swapDevices = [{
		device = "/var/lib/swapfile";
		size = 49 * 1024;
	}];

	services.logind.settings.Login = {
		IdleAction = "suspend-then-hibernate";
		IdleActionSec = "30m";
		HandlePowerKey = "hibernate";
		HandlePowerKeyLongPress = "poweroff";
	};

	programs.dconf = {
		profiles.user.databases = [{
			settings = {
				"org/gnome/settings-daemon/plugins/power" = {
					sleep-inactive-ac-type = "hibernate";
				};
			};
		}];
	};

	networking.hostName = "ser8";
	networking.networkmanager.enable = true;
	time.timeZone = "Asia/Seoul";

	system.stateVersion = "25.05";
}

