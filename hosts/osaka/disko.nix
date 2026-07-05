{
  disko.devices = {
    disk.main = {
      device = "/dev/vda";
      type = "disk";

      content = {
        type = "gpt";

        # BIOS boot partition for GRUB on a GPT disk (droplet boots legacy BIOS).
        partitions.bios = {
          priority = 100;
          size = "1M";
          type = "EF02";
        };

        # GRUB can't read bcachefs, so keep the kernels on a plain ext4 /boot.
        partitions.boot = {
          priority = 200;
          size = "1G";

          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/boot";
          };
        };

        partitions.root = {
          priority = 300;
          size = "100%";

          content = {
            type = "bcachefs";
            filesystem = "main";
            # bcachefs format fails on an empty --label, so name the device.
            label = "main.main0";
          };
        };
      };
    };

    # Impermanence: root is RAM-backed and wiped on every boot.
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };

    bcachefs_filesystems.main = {
      type = "bcachefs_filesystem";

      extraFormatArgs = [
        "--compression=zstd"
        "--background_compression=zstd"
      ];

      subvolumes = {
        nix.mountpoint = "/nix";
        persist.mountpoint = "/persist";
      };
    };
  };
}
