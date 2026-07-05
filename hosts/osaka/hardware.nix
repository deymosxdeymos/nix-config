{ ... }:
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

  # disko already points GRUB at /dev/vda via the EF02 partition; just enable it.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = false;

  boot.loader.timeout = 2;

  # Surface boot output on the DigitalOcean console (serial + VGA).
  boot.kernelParams = [
    "console=tty1"
    "console=ttyS0,115200"
  ];
}
