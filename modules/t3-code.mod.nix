{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.t3-code;
  flake.darwinModules.t3-code =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      homebrew.casks = singleton "t3-code@nightly";
    };
}
