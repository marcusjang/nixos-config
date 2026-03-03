{ config, pkgs, ... }: let
	automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
	owner = "uid=1000,gid=100";
in {
	sops.secrets = {
		smbcreds = {
			mode = "0400";
		};
		davfs = {
			mode = "0400";
			path = "/etc/davfs2/secrets";
		};
	};

	environment.systemPackages = with pkgs; [
		cifs-utils
		davfs2
	];

	services.davfs2.enable = true;

	systemd.mounts = [
		{
			description = "NAS";
			after = [ "network-online.target" ];
			wants = [ "network-online.target" ];
			what = "//10.0.10.2/share";
			where = "/mnt/share";
			options = "credentials=${config.sops.secrets.smbcreds.path},${automount_opts},${owner}";
			type = "cifs";
		}
		{
			description = "Keepass WebDAV";
			after = [ "network-online.target" ];
			wants = [ "network-online.target" ];
			what = "https://webdav.dungeon.melange.works";
			where = "/mnt/webdav";
			options = "${automount_opts},${owner}";
			type = "davfs";
			mountConfig.TimeoutSec = 15;
		}
	];

	systemd.automounts = [
		{	
			where = "/mnt/share";
			wantedBy = [ "multi-user.target" ];
			automountConfig = {
				TimeoutIdleSec = "120";
			};
		}
		{	
			where = "/mnt/webdav";
			wantedBy = [ "multi-user.target" ];
			automountConfig = {
				TimeoutIdleSec = "120";
			};
		}
	];
}
