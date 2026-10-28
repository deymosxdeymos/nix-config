{ self, ... }:
{
  # Rex puts its own `rex` at the front of PATH, but nix-darwin resets PATH to a
  # fixed list in every shell. These are the snippets from Rex's docs:
  # https://www.superlogical.com/rex/docs/automate/cli#nix
  flake.darwinModules.default = self.darwinModules.rex;
  flake.darwinModules.rex = {
    environment.interactiveShellInit = /* bash */ ''
      if [ -n "$REX_BIN_DIR" ]; then
        export PATH="$REX_BIN_DIR:$PATH"
      fi
    '';

    programs.fish.interactiveShellInit = /* fish */ ''
      if set -q REX_BIN_DIR
          fish_add_path --path --prepend --move $REX_BIN_DIR
      end
    '';
  };
}
