{
  flake.homeModules.btop =
    { pkgs, ... }:
    {
      packages = [ pkgs.btop ];
    };
}
