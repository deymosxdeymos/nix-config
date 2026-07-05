{
  # Plain ext4 root on a GPT disk, legacy BIOS. Simple and boots reliably on the
  # DigitalOcean KVM guest. (bcachefs + impermanence live on in the thinkpad
  # experiment, where there's real console access to iterate.)
  disko.devices.disk.main = {
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

      partitions.root = {
        priority = 200;
        size = "100%";

        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/";
        };
      };
    };
  };
}
