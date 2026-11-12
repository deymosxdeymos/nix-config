{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.founder;
  flake.darwinModules.founder =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      environment.systemPackages = singleton self.packages.${pkgs.stdenv.hostPlatform.system}.founder;
    };
}
