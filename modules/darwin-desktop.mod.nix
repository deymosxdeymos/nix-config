{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.darwin-desktop;
  flake.darwinModules.darwin-desktop =
    { config, ... }:
    {
      # DOCK
      system.defaults.dock = {
        autohide = true;
        showhidden = true;

        show-recents = false;
        mru-spaces = false;

        magnification = false;
      };

      system.defaults.CustomUserPreferences."com.apple.dock" = {
        autohide-time-modifier = 0.0;
        autohide-delay = 0.0;
        expose-animation-duration = 0.0;
        springboard-show-duration = 0.0;
        springboard-hide-duration = 0.0;
        springboard-page-duration = 0.0;

        launchanim = 0;
      };

      # MENU BAR
      system.defaults.controlcenter.BatteryShowPercentage = true;

      # HIDE FROM MENU BAR: SPOTLIGHT SEARCH
      # Raycast replaces it.
      system.activationScripts.postActivation.text = /* bash */ ''
        uid=$(/usr/bin/id -u ${config.system.primaryUser})

        /bin/launchctl asuser "$uid" /usr/bin/sudo --set-home --user ${config.system.primaryUser} -- \
          /usr/bin/defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
      '';

      # FINDER
      system.defaults.finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        ShowPathbar = true;
      };

      system.defaults.NSGlobalDomain = {
        NSNavPanelExpandedStateForSaveMode = true; # Expand save panel by default.
        NSNavPanelExpandedStateForSaveMode2 = true;
        PMPrintingExpandedStateForPrint = true; # Expand print panel by default.
        PMPrintingExpandedStateForPrint2 = true;
      };
    };
}
