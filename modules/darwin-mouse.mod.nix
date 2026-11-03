{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.darwin-mouse;
  flake.darwinModules.darwin-mouse =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      homebrew.casks = singleton "scroll-reverser";

      system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = true;

      system.defaults.CustomUserPreferences."com.pilotmoon.scroll-reverser".InvertScrollingOn = true;

      launchd.user.agents.scroll-reverser.serviceConfig = {
        ProgramArguments = singleton "/Applications/Scroll Reverser.app/Contents/MacOS/Scroll Reverser";
        RunAtLoad = true;
      };
    };
}
