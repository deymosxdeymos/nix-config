{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.claude-desktop;
  flake.darwinModules.claude-desktop =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      homebrew.casks = singleton "claude";
    };
}
