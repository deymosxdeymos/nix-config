{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.darwin-mouse;
  flake.darwinModules.darwin-mouse = {
    system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = true;
  };
}
