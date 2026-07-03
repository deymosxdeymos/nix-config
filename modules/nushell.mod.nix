{
  flake.homeModules.nushell =
    {
      lib,
      osConfig,
      pkgs,
      ...
    }:
    let
      inherit (lib.meta) getExe;
      inherit (lib.modules) mkBefore;
    in
    {
      packages = [
        pkgs.pstree
      ];

      programs.nushell = {
        enable = true;

        # Bring the NixOS session environment into nushell login shells.
        envFile = mkBefore "source ${osConfig.system.build.setEnvironmentNu}\n";

        settings = {
          show_banner = false;
          edit_mode = "vi";
          highlight_resolved_externals = true;

          use_kitty_protocol = true;
          shell_integration.osc9_9 = true;

          history.file_format = "sqlite";
          history.max_size = 1000000;

          completions.algorithm = "substring";

          cursor_shape.emacs = "line";
          cursor_shape.vi_insert = "line";
          cursor_shape.vi_normal = "block";

          table.mode = "single";
          table.header_on_separator = true;
          table.footer_inheritance = true;
        };

        aliases = {
          e = "hx";

          la = "ls --all";
          ll = "ls --long";
          lla = "ls --long --all";

          cp = "cp --recursive --verbose";
          mv = "mv --verbose";
          rm = "rm --recursive --verbose";

          tree = "${getExe pkgs.eza} --tree --git-ignore --group-directories-first";
          pstree = "${getExe pkgs.pstree} -g 3";
        };

        extraConfig = ''
          ulimit --file-descriptor-count hard

          $env.config.table.missing_value_symbol = $"(ansi magenta_bold)nope(ansi reset)"

          # Create a directory and cd into it.
          def --env mc [path: path]: nothing -> nothing {
            mkdir $path
            cd $path
          }

          # Create a directory, cd into it and initialize version control.
          def --env mcg [path: path]: nothing -> nothing {
            mkdir $path
            cd $path
            jj git init
          }
        '';
      };
    };
}
