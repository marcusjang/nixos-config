{ ... }:
{
	disko.devices = {
		disk = {
			main = {
				device = "/dev/disk/by-id/some-disk-id";
				type = "disk";
				content = {
					type = "gpt";
					partitions = {
						ESP = {
							type = "EF00";
							size = "64M";
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
				device = "/dev/disk/by-id/some-disk-id";
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
				device = "/dev/disk/by-id/some-disk-id";
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
				device = "/dev/disk/by-id/some-disk-id";
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
				device = "/dev/disk/by-id/some-disk-id";
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
						options = {
							sharesmb = "on";
							acltype = "posixacl";
							xattr = "sa";
						};
					};
				};
			};
		};
	};
}
