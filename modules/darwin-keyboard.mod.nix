{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.darwin-keyboard;
  flake.darwinModules.darwin-keyboard = {
    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToControl = true;

    system.defaults.NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      AppleKeyboardUIMode = 3;

      "com.apple.keyboard.fnState" = false;

      InitialKeyRepeat = 15;
      KeyRepeat = 2;

      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticInlinePredictionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };
  };
}
