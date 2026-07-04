{
  flake.nixosModules.hardware =
    { ... }:
    {
      # FIRMWARE
      hardware.enableRedistributableFirmware = true;

      # POWER MANAGEMENT
      # watt owns governor/EPP/EPB/turbo, frequency caps, and battery charge
      # thresholds in one daemon, and adds thermal-throttle protection the old
      # TLP setup lacked. It conflicts with power-profiles-daemon (pulled in by
      # Plasma) and TLP, so PPD stays off.
      services.power-profiles-daemon.enable = false;

      services.watt = {
        enable = true;

        # This mirrors watt's upstream default ruleset verbatim (see the clone at
        # ~/Documents/clones/watt/watt/config.toml) so we keep its hardware-guarded
        # tuning, with the ThinkPad-native 75/80 charge cap added to the always-on
        # priority-0 rule. Providing settings replaces the built-in defaults
        # wholesale, hence the full copy. Rules merge highest-priority-first, so
        # no higher rule sets charge thresholds and the merge always falls through
        # to the priority-0 rule to apply them.
        settings.rule = [
          {
            name = "emergency-thermal-protection";
            priority = 100;
            "if" = {
              is-more-than = 85.0;
              value = "$cpu-temperature";
            };

            cpu.energy-perf-bias = {
              "if".is-energy-perf-bias-available = "power";
              "then" = "power";
            };
            cpu.energy-performance-preference = {
              "if".is-energy-performance-preference-available = "power";
              "then" = "power";
            };
            cpu.frequency-mhz-maximum = {
              "if" = "?frequency-available";
              "then" = 2000;
            };
            cpu.governor = {
              "if".is-governor-available = "powersave";
              "then" = "powersave";
            };
            cpu.turbo = {
              "if" = "?turbo-available";
              "then" = false;
            };
          }

          {
            name = "critical-battery-preservation";
            priority = 90;
            "if".all = [
              "?discharging"
              {
                is-less-than = 0.3;
                value = "%power-supply-charge";
              }
            ];

            cpu.energy-perf-bias = {
              "if".is-energy-perf-bias-available = "power";
              "then" = "power";
            };
            cpu.energy-performance-preference = {
              "if".is-energy-performance-preference-available = "power";
              "then" = "power";
            };
            cpu.governor = {
              "if".is-governor-available = "powersave";
              "then" = "powersave";
            };
            cpu.turbo = {
              "if" = "?turbo-available";
              "then" = false;
            };
            power.platform-profile = {
              "if".is-platform-profile-available = "low-power";
              "then" = "low-power";
            };
          }

          {
            name = "high-load-performance-sustainance";
            priority = 80;
            "if".all = [
              {
                is-more-than = 0.8;
                value.cpu-usage-since = "2sec";
              }
              {
                is-less-than = 30.0;
                value = "$cpu-idle-seconds";
              }
              {
                is-less-than = 75.0;
                value = "$cpu-temperature";
              }
            ];

            cpu.energy-perf-bias = {
              "if".all = [
                { not.is-driver-loaded = "intel_pstate"; }
                { is-energy-perf-bias-available = "performance"; }
              ];
              "then" = "performance";
            };
            cpu.energy-performance-preference = {
              "if".all = [
                { not.is-driver-loaded = "intel_pstate"; }
                { is-energy-performance-preference-available = "performance"; }
              ];
              "then" = "performance";
            };
            cpu.governor = {
              "if".is-governor-available = "performance";
              "then" = "performance";
            };
            cpu.turbo = {
              "if" = "?turbo-available";
              "then" = true;
            };
          }

          {
            name = "plugged-in-performance";
            priority = 70;
            "if".all = [
              { not = "?discharging"; }
              {
                is-more-than = 0.1;
                value.cpu-usage-since = "1sec";
              }
              {
                is-less-than = 80.0;
                value = "$cpu-temperature";
              }
            ];

            cpu.energy-perf-bias = {
              "if".all = [
                { not.is-driver-loaded = "intel_pstate"; }
                { is-energy-perf-bias-available = "balance-performance"; }
              ];
              "then" = "balance-performance";
            };
            cpu.energy-performance-preference = {
              "if".all = [
                { not.is-driver-loaded = "intel_pstate"; }
                { is-energy-performance-preference-available = "performance"; }
              ];
              "then" = "performance";
            };
            cpu.governor = {
              "if".is-governor-available = "performance";
              "then" = "performance";
            };
            cpu.turbo = {
              "if" = "?turbo-available";
              "then" = true;
            };
          }

          {
            name = "moderate-load-balanced-performance";
            priority = 60;
            "if".all = [
              {
                is-more-than = 0.4;
                value.cpu-usage-since = "5sec";
              }
              {
                is-less-than = 0.8;
                value.cpu-usage-since = "5sec";
              }
            ];

            cpu.energy-perf-bias = {
              "if".is-energy-perf-bias-available = "balance-performance";
              "then" = "balance-performance";
            };
            cpu.energy-performance-preference = {
              "if".is-energy-performance-preference-available = "balance_performance";
              "then" = "balance_performance";
            };
            cpu.governor = {
              "if".is-governor-available = "schedutil";
              "then" = "schedutil";
            };
          }

          {
            name = "low-activity-power-saving";
            priority = 50;
            "if".all = [
              {
                is-less-than = 0.2;
                value.cpu-usage-since = "10sec";
              }
              {
                is-more-than = 60.0;
                value = "$cpu-idle-seconds";
              }
            ];

            cpu.energy-perf-bias = {
              "if".is-energy-perf-bias-available = "power";
              "then" = "power";
            };
            cpu.energy-performance-preference = {
              "if".is-energy-performance-preference-available = "power";
              "then" = "power";
            };
            cpu.governor = {
              "if".is-governor-available = "powersave";
              "then" = "powersave";
            };
            cpu.turbo = {
              "if" = "?turbo-available";
              "then" = false;
            };
          }

          {
            name = "extended-idle-power-saving";
            priority = 40;
            "if" = {
              is-more-than = 300.0;
              value = "$cpu-idle-seconds";
            };

            cpu.energy-perf-bias = {
              "if".is-energy-perf-bias-available = "power";
              "then" = "power";
            };
            cpu.energy-performance-preference = {
              "if".is-energy-performance-preference-available = "power";
              "then" = "power";
            };
            cpu.frequency-mhz-maximum = {
              "if" = "?frequency-available";
              "then" = 1600;
            };
            cpu.governor = {
              "if".is-governor-available = "powersave";
              "then" = "powersave";
            };
            cpu.turbo = {
              "if" = "?turbo-available";
              "then" = false;
            };
          }

          {
            name = "discharging-battery-conservation";
            priority = 30;
            "if".all = [
              "?discharging"
              {
                is-less-than = 0.5;
                value = "%power-supply-charge";
              }
            ];

            cpu.energy-perf-bias = {
              "if".is-energy-perf-bias-available = "power";
              "then" = "power";
            };
            cpu.energy-performance-preference = {
              "if".is-energy-performance-preference-available = "power";
              "then" = "power";
            };
            cpu.frequency-mhz-maximum = {
              "if" = "?frequency-available";
              "then" = 2000;
            };
            cpu.governor = {
              "if".is-governor-available = "powersave";
              "then" = "powersave";
            };
            cpu.turbo = {
              "if" = "?turbo-available";
              "then" = false;
            };
            power.platform-profile = {
              "if".is-platform-profile-available = "low-power";
              "then" = "low-power";
            };
          }

          {
            name = "battery-balanced";
            priority = 20;
            "if" = "?discharging";

            cpu.energy-perf-bias = {
              "if".is-energy-perf-bias-available = "balance-performance";
              "then" = "balance-performance";
            };
            cpu.energy-performance-preference = {
              "if".is-energy-performance-preference-available = "power";
              "then" = "power";
            };
            cpu.frequency-mhz-maximum = {
              "if" = "?frequency-available";
              "then" = 1800;
            };
            cpu.frequency-mhz-minimum = {
              "if" = "?frequency-available";
              "then" = 200;
            };
            cpu.governor = {
              "if".is-governor-available = "powersave";
              "then" = "powersave";
            };
            cpu.turbo = {
              "if" = "?turbo-available";
              "then" = false;
            };
          }

          {
            name = "default-balanced";
            priority = 0;

            cpu.energy-perf-bias = {
              "if".is-energy-perf-bias-available = "balance-performance";
              "then" = "balance-performance";
            };
            cpu.energy-performance-preference = {
              "if".is-energy-performance-preference-available = "balance_performance";
              "then" = "balance_performance";
            };
            cpu.governor = {
              "if".is-governor-available = "schedutil";
              "then" = "schedutil";
            };

            # Preserve battery health by capping charge. ThinkPad-native 75/80.
            power.charge-threshold-start = 75;
            power.charge-threshold-end = 80;
          }
        ];
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
