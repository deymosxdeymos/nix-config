{ pkgs, ... }:
{
  # DigitalOcean KVM guest (virtio devices), legacy BIOS boot.
  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "virtio_blk"
    "sd_mod"
    "sr_mod"
  ];

  # bcachefs was dropped from the mainline kernel, so ride the latest kernel that
  # still ships the module and make it available in the initrd to mount /nix.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "bcachefs" ];

  boot.loader.grub = {
    enable = true;
    devices = [ "/dev/vda" ];
    efiSupport = false;
  };

  boot.loader.timeout = 2;
}
