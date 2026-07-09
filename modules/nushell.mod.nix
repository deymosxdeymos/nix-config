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
      git = getExe pkgs.gitMinimal;
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

          # GIT
          s = "${git} status";
          gst = "${git} status";
          gaa = "${git} add --all";
          gc = "${git} commit";
          gcm = "${git} checkout main";
          co = "${git} checkout";
          gd = "${git} diff";
          gdc = "${git} diff --cached";
          up = "${git} push";
          upf = "${git} push --force";
          pu = "${git} pull";
          pur = "${git} pull --rebase";
          fe = "${git} fetch";
          re = "${git} rebase";
          lr = "${git} l --max-count 30";
          hs = "${git} rev-parse --short HEAD";
          hm = "${git} log --format=%B --max-count 1 HEAD";
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

          # cd to the git repository root.
          def --env cdr []: nothing -> nothing {
            cd (${git} rev-parse --show-toplevel | str trim)
          }

          # [f]uzzy check[o]ut a branch.
          def fo []: nothing -> nothing {
            let branch = (
              ${git} branch --no-color "--sort=-committerdate" --format='%(refname:short)'
              | ${getExe pkgs.fzf} --header 'git checkout'
              | str trim
            )
            if ($branch | is-not-empty) {
              ${git} checkout $branch
            }
          }

          # [p]ull request check[o]ut.
          def po []: nothing -> nothing {
            let branch = (
              ${getExe pkgs.gh} pr list --author "@me"
              | ${getExe pkgs.fzf} --header 'checkout PR'
              | ${getExe pkgs.gawk} '{print $(NF-5)}'
              | str trim
            )
            if ($branch | is-not-empty) {
              ${git} checkout $branch
            }
          }
        '';
      };
    };
}
