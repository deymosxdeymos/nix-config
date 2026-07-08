{
  flake.homeModules.zellij =
    { pkgs, ... }:
    {
      packages = [ pkgs.zellij ];
    };
}
