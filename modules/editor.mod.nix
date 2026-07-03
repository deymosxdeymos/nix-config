{
  flake.homeModules.editor =
    { pkgs, ... }:
    {
      # Language servers (helix itself is installed by rum).
      packages = [
        pkgs.basedpyright
        pkgs.deno
        pkgs.gopls
        pkgs.lua-language-server
        pkgs.marksman
        pkgs.nil
        pkgs.nixfmt
        pkgs.rust-analyzer
        pkgs.texlab
        pkgs.vscode-langservers-extracted
        pkgs.yaml-language-server
      ];

      rum.programs.helix = {
        enable = true;

        settings = {
          theme = "gruvbox_dark_hard";

          editor = {
            auto-completion = false;
            bufferline = "multiple";
            color-modes = true;
            cursorline = true;
            file-picker.hidden = false;
            idle-timeout = 0;
            text-width = 100;
          };

          editor.cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          editor.statusline.mode = {
            insert = "INSERT";
            normal = "NORMAL";
            select = "SELECT";
          };

          editor.indent-guides = {
            character = "|";
            render = true;
          };

          editor.whitespace.render.tab = "all";

          keys.normal.D = "extend_to_line_end";
          keys.select.D = "extend_to_line_end";
        };

        languages = {
          language-server.rust-analyzer.config = {
            cargo.features = "all";
            check.command = "clippy";
          };

          language = [
            {
              name = "nix";
              auto-format = true;
              formatter.command = "nixfmt";
            }
            {
              name = "python";
              auto-format = true;
              language-servers = [
                "basedpyright"
              ];
            }
            {
              name = "rust";
              auto-format = true;
            }
            {
              name = "typescript";
              auto-format = true;
              formatter.command = "deno";
              formatter.args = [
                "fmt"
                "--ext"
                "ts"
                "-"
              ];
            }
            {
              name = "javascript";
              auto-format = true;
              formatter.command = "deno";
              formatter.args = [
                "fmt"
                "--ext"
                "js"
                "-"
              ];
            }
            {
              name = "json";
              auto-format = true;
              formatter.command = "deno";
              formatter.args = [
                "fmt"
                "--ext"
                "json"
                "-"
              ];
            }
            {
              name = "markdown";
              auto-format = true;
            }
          ];
        };
      };
    };
}
