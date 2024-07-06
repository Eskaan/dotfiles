{ settings, lib, pkgs, ... }: {
  disko.devices = {
    disk = {
      main-storage = {
        device = settings.system.disks.main;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = lib.mkIf (settings.system.bootMode == "bios") {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
      hdd-backup = {
        type = "disk";
        device = settings.system.disks.backup;
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "hdd-backup";
              };
            };
          };
        };
      };
    };
    zpool = {
      hdd-backup = {
        mountpoint = "/hdd-backup";
        type = "zpool";
        mode = "";
        options = {
          ashift = "12";
        };
        rootFsOptions = {
          compression = "zstd";
          atime = "off";
          xattr = "sa";
          recordsize = "128K";
        };
      };
    };
  };

  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  #äboot.zfs.extraPools = [ "hdd-backup" ];
  environment.systemPackages = with pkgs; [ linuxPackages.zfs ];
}
