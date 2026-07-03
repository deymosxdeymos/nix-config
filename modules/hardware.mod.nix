{
  flake.nixosModules.hardware =
    { ... }:
    {
      # FIRMWARE
      hardware.enableRedistributableFirmware = true;

      # POWER MANAGEMENT
      # TLP owns battery charge thresholds and CPU power tuning. It conflicts
      # with power-profiles-daemon (pulled in by Plasma), so that stays off.
      services.power-profiles-daemon.enable = false;

      services.tlp = {
        enable = true;

        settings = {
          # Preserve battery health by capping charge. ThinkPad-native thresholds.
          START_CHARGE_THRESH_BAT0 = 75;
          STOP_CHARGE_THRESH_BAT0 = 80;

          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          PLATFORM_PROFILE_ON_AC = "performance";
          PLATFORM_PROFILE_ON_BAT = "low-power";

          # Keep USB peripherals responsive rather than autosuspending them.
          USB_AUTOSUSPEND = 0;
        };
      };

      # LID AND SLEEP
      services.logind.settings.Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "suspend";
        HandleLidSwitchDocked = "ignore";
      };

      # FILESYSTEM MAINTENANCE
      # Root is btrfs; scrub monthly to detect and repair bitrot.
      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
      };
    };
}
