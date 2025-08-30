{ pkgs, config, ... }:
{
	users = {
		groups = {
			"samba" = {
				gid = 1001;
			};
		};
		users = {
			"nas" = {
				uid = 1001;
				isNormalUser = false;
				isSystemUser = true;
				group = "samba";
				hashedPasswordFile = config.sops.secrets."user/nas/password".path;
			};
		};
	};

	system.activationScripts = {
		init_smbpasswd.text = ''
			/run/current-system/sw/bin/printf "$(/run/current-system/sw/bin/cat ${config.sops.secrets."user/nas/password".path})\n$(/run/current-system/sw/bin/cat ${config.sops.secrets."user/nas/password".path})\n" | /run/current-system/sw/bin/smbpasswd -sa nas
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
					"force group" = "samba";
					"force user" = "nas";
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
					"valid users" = "nas";
				};
				"drive1" = {
					"comment" = "NAS Drive 1";
					"path" = "/mnt/drive1/shared";
					"read only" = "No";
					"valid users" = "nas";
				};
				"drive2" = {
					"comment" = "NAS Drive 2";
					"path" = "/mnt/drive2/shared";
					"read only" = "No";
					"valid users" = "nas";
				};
				"drive3" = {
					"comment" = "NAS Drive 3";
					"path" = "/mnt/drive3/shared";
					"read only" = "No";
					"valid users" = "nas";
				};
				"Time Machine Backup" = {
					"comment" = "Time Machine Backup";
					"path" = "/mnt/time-machine/data";
					"read only" = "No";
					"valid users" = "nas";
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
