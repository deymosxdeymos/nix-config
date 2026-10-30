{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.vesktop;
  flake.darwinModules.vesktop =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      homebrew.casks = singleton "vesktop";
    };
}
