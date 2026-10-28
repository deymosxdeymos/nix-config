{ self, ... }:
{
  flake.homeModules.default = self.homeModules.ripgrep;
  flake.homeModules.ripgrep =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.cli) toCommandLine;
      inherit (lib.lists) singleton;
      inherit (lib.strings) concatLines;
    in
    {
      environment.sessionVariables.RIPGREP_CONFIG_PATH = "${config.xdg.config.directory}/ripgrep/config";

      packages = singleton pkgs.ripgrep;

      xdg.config.files."ripgrep/config".generator =
        attrs:
        attrs
        |> toCommandLine (name: {
          option = "--${name}";
          sep = null;
          explicitBool = false;
        })
        |> concatLines;
      xdg.config.files."ripgrep/config".value = {
        line-number = true;
        smart-case = true;
      };
    };
}
