{ inputs, outputs, lib, config, pkgs, ... }: let
	zfsCompatibleKernelPackages = lib.filterAttrs (
		name: kernelPackages:
		(builtins.match "linux_[0-9]+_[0-9]+" name) != null
		&& (builtins.tryEval kernelPackages). success
		&& (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
	) pkgs.linuxKernel.packages;
	latestKernelPackage = lib.last (
		lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
			builtins.attrValues zfsCompatibleKernelPackages
		)
	);
in {
	imports =[
		outputs.nixosModules.default
		inputs.hardware.nixosModules.common-cpu-amd
		inputs.hardware.nixosModules.common-cpu-amd-pstate
		inputs.hardware.nixosModules.common-cpu-amd-zenpower
		inputs.hardware.nixosModules.common-gpu-amd
		inputs.hardware.nixosModules.common-pc-ssd

		./hardware-configuration.nix
		./disko.nix
	];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.kernelPackages = latestKernelPackage;
	boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
	boot.kernel.sysctl."net.ipv6.ip_forward" = 1;
	
	boot.supportedFilesystems = [ "zfs" ];
	boot.zfs.forceImportRoot = false;

	environment.systemPackages = [ pkgs.unstable.disko ];

	services.zfs.autoScrub.enable = true;
	services.zfs.trim.enable = true;

	networking.hostId = "8425e349";
	networking.hostName = "n5";
	networking.networkmanager.enable = true;
	networking.firewall.allowedTCPPorts = [
		80 # http
		443 # https
		3923 # copyparty
		8581 # homebridge
	];
	networking.firewall.allowedTCPPortRanges = [
		{ from = 52950; to = 52999; } # homebridge
	];
	networking.firewall.allowedUDPPorts = [
		1900 # homebridge SSDP
	];
	networking.firewall.allowedUDPPortRanges = [
		{ from = 52950; to = 52999; } # homebridge
	];

	users.groups.nas = { };

	time.timeZone = "Asia/Seoul";

	services.thermald.enable = true;

	system.stateVersion = "25.11";
}

