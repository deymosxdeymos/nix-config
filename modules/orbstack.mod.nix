{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.orbstack;
  flake.darwinModules.orbstack =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      homebrew.casks = singleton "orbstack";
    };
}
