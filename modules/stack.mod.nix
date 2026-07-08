{ self, ... }:
{
  flake.homeModules.stack =
    { pkgs, ... }:
    {
      packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.stack
      ];
    };
}
