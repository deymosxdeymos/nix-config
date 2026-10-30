{ inputs, self, ... }:
{
  flake.darwinModules.default = self.darwinModules.amp;
  flake.darwinModules.amp =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      homebrew.brews = singleton "ampcode/tap/ampcode";

      nix-homebrew.taps."ampcode/homebrew-tap" = inputs.homebrew-ampcode;
      nix-homebrew.trust.formulae = singleton "ampcode/tap/ampcode";
    };
}
