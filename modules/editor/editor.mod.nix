{ self, inputs, ... }:
{
  flake.darwinModules.default = self.darwinModules.editor;
  flake.darwinModules.editor = {
    environment.variables.EDITOR = "hx";
  };

  flake.homeModules.default = self.homeModules.editor;
  flake.homeModules.editor =
    {
      lib,
      osConfig,
      pkgs,
      ...
    }:
    let
      inherit (lib.attrsets) attrValues genAttrs mapAttrs;
      inherit (lib.lists) optional;
      inherit (lib.meta) getExe;
      inherit (lib.trivial) const;

      localBin = pkgs.writeShellApplication {
        name = "node-local-bin";
        text = /* bash */ ''
          name=$1
          shift

          directory=$PWD
          while [ "$directory" != / ]; do
            if [ -x "$directory/node_modules/.bin/$name" ]; then
              exec "$directory/node_modules/.bin/$name" "$@"
            fi
            directory=$(dirname "$directory")
          done

          exit 127
        '';
      };

      typescriptServer = pkgs.writeShellApplication {
        name = "typescript-server";
        runtimeInputs = [ localBin ];
        text = /* bash */ ''
          if node-local-bin tsc --version 2>/dev/null | grep --quiet '^Version [7-9]'; then
            exec node-local-bin tsc --lsp --stdio
          fi

          exec ${getExe pkgs.typescript-language-server} --stdio
        '';
      };

      oxfmt = pkgs.writeShellApplication {
        name = "oxfmt-or-cat";
        runtimeInputs = [ localBin ];
        text = /* bash */ ''
          input=$(cat)

          if ! printf '%s' "$input" | node-local-bin oxfmt "$@"; then
            printf '%s' "$input"
          fi
        '';
      };
    in
    {
      environment.sessionVariables.EDITOR = "hx";

      packages = [
        inputs.helix.packages.${osConfig.nixpkgs.hostPlatform.system}.default
        pkgs.neovim

        pkgs.lua-language-server
        pkgs.markdown-oxide
        pkgs.nil
        pkgs.nixfmt
        pkgs.ruff
        pkgs.rust-analyzer
        pkgs.tailwindcss-language-server
        pkgs.ty
        pkgs.typescript-language-server
        pkgs.vscode-langservers-extracted
        pkgs.yaml-language-server
      ];

      xdg.config.files."nvim/init.lua".source = ./init.lua;

      xdg.config.files."helix/config.toml".generator = pkgs.writers.writeTOML "helix-config.toml";
      xdg.config.files."helix/config.toml".value = {
        theme = {
          dark = "rasmus";
          light = "catppuccin_latte";
        };

        editor = {
          bufferline = "multiple";
          color-modes = true;
          cursorline = true;
          file-picker.hidden = false;
          lsp.display-inlay-hints = true;
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
          character = "▏";
          render = true;
        };

        editor.whitespace = {
          characters.tab = "→";
          render.tab = "all";
        };

        keys =
          genAttrs [
            "normal"
            "select"
          ]
          <| const {
            D = "extend_to_line_end";
          };
      };

      xdg.config.files."helix/languages.toml".generator = pkgs.writers.writeTOML "helix-languages.toml";
      xdg.config.files."helix/languages.toml".value = {
        language-server.typescript.command = getExe typescriptServer;

        language-server.oxlint = {
          command = getExe localBin;
          args = [
            "oxlint"
            "--lsp"
          ];
        };

        language-server.rust-analyzer.config = {
          cargo.features = "all";
          check.command = "clippy";
          completion.callable.snippets = "add_parentheses";
          diagnostics.disabled = [
            "inactive-code"
            "unlinked-file"
          ];
        };

        language =
          (
            {
              javascript = "js";
              json = "json";
              jsonc = "jsonc";
              jsx = "jsx";
              tsx = "tsx";
              typescript = "ts";
            }
            |> mapAttrs (
              name: extension: {
                inherit name;

                auto-format = true;
                formatter.command = getExe oxfmt;
                formatter.args = [ "--stdin-filepath=file.${extension}" ];

                language-servers =
                  if name == "json" || name == "jsonc" then
                    [ "vscode-json-language-server" ]
                  else
                    [
                      "typescript"
                      "oxlint"
                    ]
                    ++ optional (name == "jsx" || name == "tsx") "tailwindcss-ls";
              }
            )
            |> attrValues
          )
          ++ [
            {
              name = "nix";
              auto-format = true;
              formatter.command = getExe pkgs.nixfmt;
            }
          ];
      };
    };
}
