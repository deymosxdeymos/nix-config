{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.t3code;
  flake.darwinModules.t3code =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      homebrew.casks = singleton "t3-code@nightly";
    };
}
