{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.unshittify;
  flake.darwinModules.unshittify = {
    system.defaults.loginwindow = {
      DisableConsoleAccess = true;
      GuestEnabled = false;
    };

    system.defaults.CustomUserPreferences."com.apple.screensaver" = {
      askForPassword = 1;
      askForPasswordDelay = 0;
    };

    system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;

    system.defaults.LaunchServices.LSQuarantine = false;

    system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

    system.defaults.CustomUserPreferences."com.apple.AdLib" = {
      allowApplePersonalizedAdvertising = false;
      allowIdentifierForAdvertising = false;
      forceLimitAdTracking = true;
      personalizedAdsMigrated = false;
    };
  };
}
