{
  flake.homeModules.bat =
    { pkgs, ... }:
    {
      packages = [ pkgs.bat ];
    };
}
