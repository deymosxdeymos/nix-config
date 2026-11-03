{ inputs, self, ... }:
{
  flake.homeModules.default = self.homeModules.ghidra;
  flake.homeModules.ghidra =
    { pkgs, lib, ... }:
    let
      inherit (lib.lists) singleton;
      ghidra = inputs.ghidra-nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.ghidra;
    in
    {
      packages = singleton ghidra;
    };
}
