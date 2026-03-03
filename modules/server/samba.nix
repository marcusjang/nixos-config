{ pkgs, lib, config, ... }:
let
    setPassword = pkgs.writeShellScript "samba-set-password" ''
        set -euo pipefail
        smb_password="$(${lib.getExe' pkgs.coreutils "cat"} ${config.sops.secrets."user/samba/password".path})"
        ${lib.getExe' pkgs.coreutils "echo"} -e "$smb_password\n$smb_password\n" |
        ${lib.getExe' pkgs.samba "smbpasswd"} -sa ${config.users.users."samba".name}
    '';
in	
{
	sops.secrets."user/samba/password" = {
		mode = "0400";
		restartUnits = [ "samba-smbd.service" ];
	};

	users.users."samba" = {
		isSystemUser = true;
		group = "nas";
		hashedPasswordFile = config.sops.secrets."user/samba/password".path;
	};

	systemd.services.samba-smbd.serviceConfig.ExecStartPre = [
		"${setPassword}"
	];

	services.avahi = {
		enable = true;
		nssmdns4 = true;
		nssmdns6 = true;
		publish = {
			enable = true;
			addresses = true;
			domain = true;
			userServices = true;
			workstation = true;
		};
		openFirewall = true;
	};

	services.samba = {
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
				"usershare owner only" = "No";
				"usershare max shares" = "100";
				"usershare path" = "/var/lib/samba/usershares";
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
		};
	};

	services.samba-wsdd = {
		enable = true;
		openFirewall = true;
	};
}
