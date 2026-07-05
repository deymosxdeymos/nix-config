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
  # still ships the module. It must be in the initrd to mount the bcachefs /nix,
  # otherwise the first boot hangs before the console even attaches.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "bcachefs" ];
  boot.initrd.supportedFilesystems = [ "bcachefs" ];
  boot.initrd.kernelModules = [ "bcachefs" ];

  # Surface boot output on the DigitalOcean console (serial + VGA) so a hung
  # boot is actually diagnosable instead of a black "connecting…" screen.
  boot.kernelParams = [
    "console=tty1"
    "console=ttyS0,115200"
  ];

  # disko already points GRUB at /dev/vda via the EF02 partition; just enable it.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = false;

  boot.loader.timeout = 2;
}
