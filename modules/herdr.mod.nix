{ inputs, ... }:
{
  flake.homeModules.herdr =
    { pkgs, ... }:
    {
      packages = [ inputs.herdr.packages.${pkgs.system}.default ];
    };
}
