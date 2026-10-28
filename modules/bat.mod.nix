{ self, ... }:
{
  flake.homeModules.default = self.homeModules.bat;
  flake.homeModules.bat =
    { lib, pkgs, ... }:
    let
      inherit (lib.cli) toCommandLine;
      inherit (lib.fixedPoints) fix;
      inherit (lib.generators) toLesskey;
      inherit (lib.meta) getExe;
      inherit (lib.strings) concatLines;
    in
    {
      environment.sessionVariables = fix (variables: {
        MANROFFOPT = "-c";
        MANPAGER =
          getExe
          <| pkgs.writers.writeNuBin "man-pager" /* nu */ ''
            ^${getExe pkgs.unixtools.col} -bx
            | ^${getExe pkgs.bat} --language man --plain --color always
            | ^$env.PAGER
          '';
        JJ_PAGER = variables.PAGER;
        PAGER = getExe pkgs.less;
      });

      xdg.config.files."fish/conf.d/bat.fish".text = /* fish */ ''
        alias cat ${
          getExe
          <| pkgs.writers.writeNuBin "cat" /* nu */ ''
            def --wrapped main [...arguments: string] {
              let split = $arguments | group-by {|arg| if ($arg | path exists) { "files" } else { "options" } }

              match ($split.files? | default [] | length) {
                1 if (is-terminal --stdout) => {
                  $env.LESSOPEN = $"||${getExe pkgs.bat} ($split.options? | default [] | str join ' ') --color always -- %s"
                  exec $env.PAGER ...$split.files
                }

                _ => {
                  exec ${getExe pkgs.bat} ...$arguments
                }
              }
            }
          ''
        }
      '';

      packages = [
        pkgs.bat
        pkgs.less
      ];

      xdg.config.files."lesskey".generator = toLesskey;
      xdg.config.files."lesskey".value.env.LESS = [
        "--quit-if-one-screen"
        "--quit-on-intr"

        "--ignore-case"
        "--incsearch"
        "--LONG-PROMPT"
        "--no-edit-warn"

        "--chop-long-lines"
        "--HILITE-UNREAD"
        "--tilde"

        "--RAW-CONTROL-CHARS"
      ];

      xdg.config.files."bat/config".generator =
        attrs:
        attrs
        |> toCommandLine (name: {
          option = "--${name}";
          sep = "=";
          explicitBool = false;
        })
        |> concatLines;
      xdg.config.files."bat/config".value.theme = "base16";
    };
}
