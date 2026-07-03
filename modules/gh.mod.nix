{
  flake.homeModules.gh =
    { lib, pkgs, ... }:
    let
      inherit (lib.generators) toYAML;
    in
    {
      packages = [
        pkgs.gh
      ];

      xdg.config.files."gh/config.yml".generator = toYAML { };
      xdg.config.files."gh/config.yml".value = {
        version = 1;
      };
    };
}
