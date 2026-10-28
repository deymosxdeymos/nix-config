{ self, ... }:
{
  flake.homeModules.default = self.homeModules.btop;
  flake.homeModules.btop =
    { lib, pkgs, ... }:
    let
      inherit (lib.generators) toKeyValue;
      inherit (lib.lists) singleton;
    in
    {
      packages = singleton pkgs.btop;

      xdg.config.files."btop/btop.conf".generator = toKeyValue { };
      xdg.config.files."btop/btop.conf".value = {
        color_theme = "TTY";
        theme_background = false;

        rounded_corners = true;

        show_gpu_info = "Off";
      };
    };
}
