{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.darwin-desktop;
  flake.darwinModules.darwin-desktop =
    { config, pkgs, ... }:
    {
      system.defaults.dock = {
        autohide = true;
        showhidden = true;

        show-recents = false;
        mru-spaces = false;

        magnification = false;
      };

      system.defaults.CustomUserPreferences."com.apple.dock" = {
        wvous-tl-corner = 0;
        wvous-tr-corner = 0;
        wvous-bl-corner = 0;
        wvous-br-corner = 0;
      };

      system.defaults.controlcenter.BatteryShowPercentage = true;
      system.defaults.controlcenter.Bluetooth = false;

      system.defaults.controlcenter.Display = false;
      system.defaults.CustomUserPreferences."com.apple.TextInputMenu".visible = false;
      system.activationScripts.postActivation.text = "${pkgs.writers.writeNu "hide-spotlight.nu" /* nu */ ''
        let user = r###'${config.system.primaryUser}'###
        let uid = sys users | where name == $user | get 0.id

        (^/bin/launchctl asuser $uid /usr/bin/sudo
          --set-home
          --user $user
          --
          /usr/bin/defaults
          -currentHost write com.apple.Spotlight MenuItemHidden -int 1)

        try {
          (^/bin/launchctl asuser $uid /usr/bin/sudo
            --set-home
            --user $user
            --
            /usr/bin/killall TextInputMenuAgent)
        }
      ''}";

      system.defaults.screencapture.location = "~/Downloads";

      system.defaults.finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        ShowPathbar = true;
      };

      system.defaults.NSGlobalDomain = {
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
      };
    };
}
