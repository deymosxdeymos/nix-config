{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.antigravity;
  flake.darwinModules.antigravity =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      homebrew.casks = singleton "antigravity-cli";
    };
}
