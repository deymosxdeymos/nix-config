{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.darwin-keyboard;
  flake.darwinModules.darwin-keyboard = {
    # CAPS LOCK
    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToControl = true;

    # NSGLOBALDOMAIN
    system.defaults.NSGlobalDomain = {
      ApplePressAndHoldEnabled = false; # No accent popup when you press and hold a key, just repeat it.
      AppleKeyboardUIMode = 3; # Full keyboard access.

      "com.apple.keyboard.fnState" = false; # Don't invert Fn.

      # N * 15ms to start repeating, so about 225ms.
      InitialKeyRepeat = 15;
      # N * 15ms, so 30ms between each keypress (~33 per second).
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
