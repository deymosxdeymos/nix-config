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
        # Follows the terminal's palette.
        color_theme = "TTY";
        theme_background = false;

        rounded_corners = true;

        # btop 1.4's Apple-Silicon GPU support crashes (SIGTRAP) in Cpu::draw via
        # an OOB read into the GPU vector when drawing GPU info on darwin.
        show_gpu_info = "Off";
      };
    };
}
