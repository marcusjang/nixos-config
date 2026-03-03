{ ... }:
{
	disko.devices = {
		disk = {
			main = {
				device = "/dev/disk/by-id/nvme-BAYHUB_Foresee-C9A611-0x0013-64GB_29036200000000000001";
				type = "disk";
				content = {
					type = "gpt";
					partitions = {
						ESP = {
							type = "EF00";
							size = "1G";
							content = {
								type = "filesystem";
								format = "vfat";
								mountpoint = "/boot";
								mountOptions = [ "umask=0077" ];
							};
						};
						root = {
							size = "100%";
							content = {
								type = "zfs";
								pool = "zroot";
							};
						};
					};
				};
			};
			drive0 = {
				type = "disk";
				device = "/dev/disk/by-id/ata-WDC_WDS100T2B0A-00SM50_183324801704";
				content = {
					type = "gpt";
					partitions = {
						zfs = {
							size = "100%";
							content = {
								type = "zfs";
								pool = "znas";
							};
						};
					};
				};
			};
			drive1 = {
				type = "disk";
				device = "/dev/disk/by-id/ata-SanDisk_SDSSDHII960G_151709400157";
				content = {
					type = "gpt";
					partitions = {
						zfs = {
							size = "100%";
							content = {
								type = "zfs";
								pool = "znas";
							};
						};
					};
				};
			};
			drive2 = {
				type = "disk";
				device = "/dev/disk/by-id/ata-SanDisk_Ultra_II_960GB_161416804734";
				content = {
					type = "gpt";
					partitions = {
						zfs = {
							size = "100%";
							content = {
								type = "zfs";
								pool = "znas";
							};
						};
					};
				};
			};
			drive3 = {
				type = "disk";
				device = "/dev/disk/by-id/ata-TOSHIBA-TR150_46PB30AFK8ZU";
				content = {
					type = "gpt";
					partitions = {
						zfs = {
							size = "100%";
							content = {
								type = "zfs";
								pool = "znas";
							};
						};
					};
				};
			};
		};
		zpool = {
			zroot = {
				type = "zpool";
				options.cachefile = "none";
				rootFsOptions = {
					compression = "zstd";
					"com.sun:auto-snapshot" = "false";
				};

				datasets = {
					root = { type = "zfs_fs"; mountpoint = "/"; };
					nix = { type = "zfs_fs"; mountpoint = "/nix"; };
					home = { type = "zfs_fs"; mountpoint = "/home"; };
				};
			};
			znas = {
				type = "zpool";
				mode = "raidz1";
				options.cachefile = "none";
				rootFsOptions = {
					compression = "zstd";
					"com.sun:auto-snapshot" = "false";
				};
				
				datasets = {
					zfs_fs = {
						type = "zfs_fs";
						mountpoint = "/share";
					};
					zfs_fs_webdav = {
						type = "zfs_fs";
						mountpoint = "/serve/webdav";
					};
				};
			};
		};
	};
}
