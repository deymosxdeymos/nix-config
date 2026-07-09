{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      services.xserver.enable = true;

      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;

      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      services.printing.enable = true;
      services.fstrim.enable = true;
      services.fwupd.enable = true;
      services.thermald.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      security.rtkit.enable = true;

      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;

      environment.systemPackages = [
        pkgs.kdePackages.ark
        pkgs.kdePackages.dolphin
        pkgs.kdePackages.kate
        pkgs.kdePackages.kcalc
        pkgs.kdePackages.okular
        pkgs.wl-clipboard
      ];
    };
}
