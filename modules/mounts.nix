{ pkgs, ... }: let
	automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
	credentials = "credentials=/mnt/.smbcred";
	owner = "uid=1000,gid=100";
in {
	environment.systemPackages = [ pkgs.cifs-utils ];
	fileSystems = {
		"/mnt/drive0" = {
			device = "//10.0.10.2/drive0";
			fsType = "cifs";
			options = [ "${automount_opts},${credentials},${owner}" ];
		};
		"/mnt/drive1" = {
			device = "//10.0.10.2/drive1";
			fsType = "cifs";
			options = [ "${automount_opts},${credentials},${owner}" ];
		};
		"/mnt/drive2" = {
			device = "//10.0.10.2/drive2";
			fsType = "cifs";
			options = [ "${automount_opts},${credentials},${owner}" ];
		};
		"/mnt/drive3" = {
			device = "//10.0.10.2/drive3";
			fsType = "cifs";
			options = [ "${automount_opts},${credentials},${owner}" ];
		};
	};
}
