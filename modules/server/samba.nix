{ pkgs, lib, config, ... }:
{
	sops.secrets."user/samba/password".mode = "0400";

	users.users."samba" = {
		isSystemUser = true;
		group = "nas";
		hashedPasswordFile = config.sops.secrets."user/samba/password".path;
	};

	system.activationScripts = {
		init_smbpasswd.text = ''
            ${lib.getExe' pkgs.coreutils "printf"} \
            "$(${lib.getExe' pkgs.coreutils "cat"} ${config.sops.secrets."user/samba/password".path})\n$(${lib.getExe' pkgs.coreutils "cat"} ${config.sops.secrets."user/samba/password".path})\n" |\
            ${lib.getExe' pkgs.samba "smbpasswd"} -sa ${config.users.users."samba".name}
        '';
	};

	services = {
		avahi = {
			enable = true;
			publish = {
				enable = true;
				addresses = true;
				domain = true;
				userServices = true;
				workstation = true;
			};
			openFirewall = true;
		};
		samba = {
			package = pkgs.samba4Full;
			enable = true;
			openFirewall = true;
			settings = {
				global = {
					"disable netbios" = "Yes";
					"disable spoolss" = "Yes";
					"dns proxy" = "No";
					"local master" = "No";
					"map to guest" = "Bad User";
					"pam password change" = "Yes";
					"printcap name" = "/dev/null";
					"security" = "user";
					"server role" = "standalone server";
					"server services" = "s3fs, rpc, wrepl, ldap, cldap, kdc, drepl, winbindd, ntp_signd, kcc, dnsupdate";
					"server string" = "NixOS Samba Server";
					"smb1 unix extensions" = "No";
					"smb ports" = "445";
					"usershare allow guests" = "Yes";
					"winbind scan trusted domains" = "Yes";
					"fruit:aapl" ="Yes";
					"fruit:time machine" = "Yes";
					"fruit:delete_empty_adfiles" = "Yes";
					"fruit:wipe_intentionally_left_blank_rfork" = "Yes";
					"fruit:veto_appledouble" = "No";
					"fruit:posix_rename" = "Yes";
					"fruit:model" = "MacSamba";
					"fruit:metadata" = "stream";
					"idmap config * : backend" = "tdb";
					"create mask" = "0664";
					"directory mask" = "0775";
					"force create mode" = "0664";
					"force directory mode" = "0775";
					"force group" = "nas";
					"force user" = "samba";
					"guest account" = "marcus";
					"hosts allow" = "127.0.0.0/8 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16";
					"hosts deny" = "0.0.0.0/0";
					"printing" = "bsd";
					"strict locking" = "No";
					"vfs objects" = "catia fruit streams_xattr";
					"wide links" = "Yes";
				};
				"drive0" = {
					"comment" = "NAS Drive 0";
					"path" = "/mnt/drive0/shared";
					"read only" = "No";
					"valid users" = "samba";
				};
				"drive1" = {
					"comment" = "NAS Drive 1";
					"path" = "/mnt/drive1/shared";
					"read only" = "No";
					"valid users" = "samba";
				};
				"drive2" = {
					"comment" = "NAS Drive 2";
					"path" = "/mnt/drive2/shared";
					"read only" = "No";
					"valid users" = "samba";
				};
				"drive3" = {
					"comment" = "NAS Drive 3";
					"path" = "/mnt/drive3/shared";
					"read only" = "No";
					"valid users" = "samba";
				};
				"Time Machine Backup" = {
					"comment" = "Time Machine Backup";
					"path" = "/mnt/time-machine/data";
					"read only" = "No";
					"valid users" = "samba";
					"writeable" = "Yes";
				};
			};
		};
		samba-wsdd = {
			enable = true;
			openFirewall = true;
		};
	};
}
