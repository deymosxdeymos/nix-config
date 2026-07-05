{
  flake.homeModules.nushell =
    {
      lib,
      osConfig,
      pkgs,
      ...
    }:
    let
      inherit (lib.meta) getExe getExe';
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

        extraConfig = /* nu */ ''
          ulimit --file-descriptor-count hard

          if ($env.SSH_AUTH_SOCK? | is-empty) {
            let ssh_agent_socket = (^${getExe pkgs.bash} -c 'for sock in "$HOME"/.ssh/agent/*; do SSH_AUTH_SOCK="$sock" ${getExe' pkgs.openssh "ssh-add"} -L >/dev/null 2>&1 && printf "%s\n" "$sock" && exit 0; done')

            if ($ssh_agent_socket | is-not-empty) {
              $env.SSH_AUTH_SOCK = $ssh_agent_socket
            }
          }

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
