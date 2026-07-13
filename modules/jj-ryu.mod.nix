{ self, ... }:
{
  flake.homeModules.jj-ryu =
    { pkgs, ... }:
    {
      packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.jj-ryu
      ];
    };
}
