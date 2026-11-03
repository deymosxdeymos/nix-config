{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.transmission;
  flake.darwinModules.transmission =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      homebrew.casks = singleton "transmission";
    };
}
