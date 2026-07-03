{
  flake.homeModules.ripgrep =
    { pkgs, ... }:
    {
      packages = [ pkgs.ripgrep ];
    };
}
