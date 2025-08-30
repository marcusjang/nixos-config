{ pkgs, inputs, outputs, ... }: let
	automount_opts = "relatime,nofail";
in {
	imports =[
		outputs.nixosModules.default
		inputs.hardware.nixosModules.common-cpu-intel

		./hardware-configuration.nix
	];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
	boot.kernel.sysctl."net.ipv6.ip_forward" = 1;

	networking.hostName = "nas";
	networking.networkmanager.enable = true;
	networking.firewall.enable = false;
	time.timeZone = "Asia/Seoul";

	virtualisation.docker.enable = true;

	services.thermald.enable = true;

	fileSystems = {
		# WD BLUE 1TB
		"/mnt/drive0" = {
			device = "/dev/disk/by-uuid/1eed5f92-5bd4-4849-a2da-036e38df1528";
			fsType = "ext4";
			options = [ "${automount_opts}" ];
		};
		# Sandisk Ultra II 1TB
		"/mnt/drive1" = {
			device = "/dev/disk/by-uuid/58c65c5a-7a59-4230-8979-9ce8f9cd7c1e";
			fsType = "ext4";
			options = [ "${automount_opts}" ];
		};
		# Sandisk Ultra II 1TB
		"/mnt/drive2" = {
			device = "/dev/disk/by-uuid/fadf7f95-2ca5-46a7-a65c-ae16ecbb2dc3";
			fsType = "ext4";
			options = [ "${automount_opts}" ];
		};
		# Toshiba TR150 1TB
		"/mnt/drive3" = {
			device = "/dev/disk/by-uuid/e48dce21-9118-48e8-a3fc-2267ef695e23";
			fsType = "ext4";
			options = [ "${automount_opts}" ];
		};
		# Time Machine 
		"/mnt/time-machine" = {
			device = "/dev/disk/by-uuid/fed21bdf-51f3-4a54-9b67-083c091cd568";
			fsType = "ext4";
			options = [ "${automount_opts}" ];
		};
	};

	system.stateVersion = "25.05";
}

