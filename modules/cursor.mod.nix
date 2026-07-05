{
  flake.homeModules.cursor =
    { pkgs, ... }:
    {
      packages = [
        pkgs.code-cursor
      ];
    };
}
