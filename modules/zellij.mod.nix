{
  flake.homeModules.zellij =
    { config, pkgs, ... }:
    let
      inherit (config) theme;
    in
    {
      packages = [ pkgs.zellij ];

      # Catppuccin Macchiato derived from the shared base16 palette.
      xdg.config.files."zellij/config.kdl".text = # kdl
        ''
          theme "catppuccin-macchiato"

          themes {
              catppuccin-macchiato {
                  fg "#${theme.base05}"
                  bg "#${theme.base00}"
                  black "#${theme.base00}"
                  red "#${theme.base08}"
                  green "#${theme.base0B}"
                  yellow "#${theme.base0A}"
                  blue "#${theme.base0D}"
                  magenta "#${theme.base0E}"
                  cyan "#${theme.base0C}"
                  white "#${theme.base06}"
                  orange "#${theme.base09}"
              }
          }
        '';
    };
}
