{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.fish;
  flake.darwinModules.fish =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      # Sets up the nix-darwin environment in /etc/fish.
      programs.fish.enable = true;

      environment.shells = singleton pkgs.fish;
    };

  flake.homeModules.default = self.homeModules.fish;
  flake.homeModules.fish =
    { config, pkgs, ... }:
    {
      packages = [
        pkgs.eza
        pkgs.pstree
      ];

      xdg.config.files."fish/functions".source = ./functions;

      xdg.config.files."fish/config.fish".text = /* fish */ ''
        set fish_greeting

        if status is-interactive
            fish_vi_key_bindings
            set -g fish_cursor_default block
            set -g fish_cursor_insert line
            set -g fish_cursor_replace_one underscore
            set -g fish_cursor_visual block
        end

        function fish_title
            set -l cmd $argv[1]
            if test -n "$cmd"
                echo "$cmd — fish"
            else
                echo (prompt_pwd)
            end
        end
      '';

      xdg.config.files."fish/conf.d/env.fish".text = /* fish */ ''
        fish_add_path --global --prepend "$HOME/.local/bin" "$CARGO_HOME/bin" "$GOPATH/bin" "$BUN_INSTALL/bin"

        # Keep API keys and other secrets out of version control.
        set -l local_env "${config.xdg.config.directory}/fish/local-env.fish"
        if test -f $local_env
            source $local_env
        end
      '';

      xdg.config.files."fish/conf.d/aliases.fish".text = /* fish */ ''
        alias vim 'nvim'

        # ls family
        alias la 'ls --all'
        alias ll 'ls -l'
        alias lla 'ls -la'
        alias sl 'ls'

        # file ops
        alias cp 'cp --recursive --verbose'
        alias mk 'mkdir'
        alias mv 'mv --verbose'
        alias rm 'rm --recursive --verbose'

        alias pstree 'pstree -g 3'
        alias tree 'eza --tree --git-ignore --group-directories-first'
      '';
    };
}
