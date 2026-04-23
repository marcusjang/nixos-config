{ pkgs, lib, config, inputs, outputs, ... }:
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

	boot.extraModulePackages = [
		(config.boot.kernelPackages.it87.overrideAttrs (old: {
			postInstall = ((old.postInstall or "") + ''find $out -name '*.ko' -exec xz {} \;'');
		}))
	];
	boot.kernelParams = [ "acpi_enforce_resources=lax" ];
	boot.kernelModules = [ "coretemp" "it87" ];
	system.modulesTree = lib.mkForce [
		((pkgs.aggregateModules
			(config.boot.extraModulePackages ++ [ config.boot.kernelPackages.kernel.modules ])
		).overrideAttrs {
			ignoreCollisions = true;
		})
	];

	swapDevices = [{
		device = "/var/lib/swapfile";
		size = 24 * 1024;
	}];

	services.logind.settings.Login = {
		IdleAction = "suspend";
		IdleActionSec = "30m";
		HandlePowerKey = "suspend";
		HandlePowerKeyLongPress = "poweroff";
	};

	programs.dconf = {
		profiles.user.databases = [{
			settings = {
				"org/gnome/settings-daemon/plugins/power" = {
					sleep-inactive-ac-type = "suspend";
				};
			};
		}];
	};

	networking.hostName = "ser8";
	networking.networkmanager.enable = true;
	time.timeZone = "Asia/Seoul";

	system.stateVersion = "25.05";
}

