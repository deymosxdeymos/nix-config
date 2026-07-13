{ self, ... }:
{
  flake.homeModules.agent-run =
    { pkgs, ... }:
    {
      packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.agent-run
      ];
    };
}
