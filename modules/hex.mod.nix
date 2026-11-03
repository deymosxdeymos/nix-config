{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.hex;
  flake.darwinModules.hex =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      homebrew.casks = singleton "anomalyco/tap/hex";
    };
}
