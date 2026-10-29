{ inputs, self, ... }:
{
  flake.darwinModules.default = self.darwinModules.ardia;
  flake.darwinModules.ardia =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      homebrew.casks = singleton "mantrakp04/tap/ardia";

      nix-homebrew.taps."mantrakp04/homebrew-tap" = inputs.homebrew-mantrakp04;
      nix-homebrew.trust.casks = singleton "mantrakp04/tap/ardia";
    };
}
