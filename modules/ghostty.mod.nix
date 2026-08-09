{
  flake.homeModules.ghostty =
    { config, ... }:
    {
      rum.programs.ghostty = {
        enable = true;

        settings = {
          font-family = config.theme.font.mono.name;
          font-size = config.theme.font.size.normal;

          theme = "dark:Catppuccin Macchiato,light:Catppuccin Latte";

          desktop-notifications = false;

          gtk-titlebar = false;

          window-padding-x = config.theme.padding;
          window-padding-y = config.theme.padding;

          # 100 MiB
          scrollback-limit = 100 * 1024 * 1024;

          mouse-hide-while-typing = true;
          quit-after-last-window-closed = true;

          keybind = [
            "alt+h=goto_split:left"
            "alt+j=goto_split:down"
            "alt+k=goto_split:up"
            "alt+l=goto_split:right"
            "ctrl+k=toggle_command_palette"
          ];
        };
      };
    };
}
