{ inputs, outputs, ... }:
{
	imports =[
		outputs.nixosModules.default
		inputs.hardware.nixosModules.chuwi-minibook-x

		./hardware-configuration.nix
	];

	boot.loader.limine = {
		enable = true;
		efiSupport = true;
		maxGenerations = 4;
		extraConfig = ''
            interface_rotation: 90
        '';
		style = {
			wallpapers = [ ];
			graphicalTerminal = {
				font = {
					scale = "2x2";
				};
			};
		};
	};
	boot.loader.efi.canTouchEfiVariables = true;

	boot.kernelParams = [ "mem_sleep_default=deep" ];

	networking.hostName = "minibook";
	networking.networkmanager.enable = true;
	time.timeZone = "Asia/Seoul";

	systemd.sleep.extraConfig = ''
        SuspendState=mem
    '';

	system.stateVersion = "24.11";
}

