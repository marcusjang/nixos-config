{ pkgs, inputs, outputs, ... }:
{
	imports = [
		outputs.nixosModules.default
		inputs.hardware.nixosModules.lenovo-thinkpad-x1-13th-gen

		./hardware-configuration.nix
	];

	boot.loader.systemd-boot.enable = true;
	boot.loader.systemd-boot.consoleMode = "5";
	boot.loader.systemd-boot.configurationLimit = 4;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.kernelPackages = pkgs.linuxPackages_7_1;
	#boot.kernelPackages = pkgs.linuxPackages_latest;

	services.fprintd.enable = true;
	#services.fprintd.tod.enable = true;
	#services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix-550a;
	services.fwupd.enable = true;

	services.thermald.enable = true;

	services.keyd = {
		enable = true;
		keyboards = {
			defaults = {
				ids = [ "0001:0001:09b4e68d" ];
				settings = {
					main = { "f23+leftshift+leftmeta" = "rightcontrol"; };
				};
			};
		};
	};

	networking.hostName = "x1c13";
	networking.networkmanager.enable = true;
	time.timeZone = "Asia/Seoul";

	system.stateVersion = "25.11";
}

