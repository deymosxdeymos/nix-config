{
  flake.homeModules.zellij =
    { config, pkgs, ... }:
    let
      inherit (config) theme;
    in
    {
      packages = [ pkgs.zellij ];

      # Gruvbox Dark Hard, derived from the base16 palette (base00 = hard bg)
      # rather than zellij's built-in theme name, to stay in sync with the
      # rest of the system theme.
      xdg.config.files."zellij/config.kdl".text = # kdl
        ''
          theme "gruvbox-dark-hard"

          themes {
              gruvbox-dark-hard {
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
