{ inputs, self, ... }:
{
  flake.darwinModules.default = self.darwinModules.pond;
  flake.darwinModules.pond =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      homebrew.casks = singleton "raphaelsalaja/pond/pond";

      nix-homebrew.taps."raphaelsalaja/homebrew-pond" = inputs.homebrew-pond;
    };
}
