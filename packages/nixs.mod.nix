{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      inherit (lib.meta) getExe;
    in
    {
      packages.nixs = pkgs.writeScriptBin "nixs" /* bash */ ''
        #!${getExe pkgs.bash}
        set -euo pipefail

        deny_argument() {
          case "$1" in
            --arg-from-file|--arg-from-stdin|--commit-lock-file|--debugger|--eval-store|--include|--inputs-from|--option|--output-lock-file|--override-flake|--override-input|--recreate-lock-file|--reference-lock-file|--repair|--store|--to|--update-input|--write-to|-I) return 0 ;;
            --arg-from-file=*|--arg-from-stdin=*|--commit-lock-file=*|--debugger=*|--eval-store=*|--include=*|--inputs-from=*|--option=*|--output-lock-file=*|--override-flake=*|--override-input=*|--recreate-lock-file=*|--reference-lock-file=*|--repair=*|--store=*|--to=*|--update-input=*|--write-to=*|-I*) return 0 ;;
            *) return 1 ;;
          esac
        }

        case "''${1-} ''${2-}" in
          "--version ") command=(--version) ;;
          "help "*) command=("$@") ;;
          "config show"*) command=("$@") ;;
          "eval "*) command=(eval --read-only "''${@:2}") ;;
          "registry list") command=(registry list) ;;
          "flake archive"*) command=(flake archive --no-write-lock-file "''${@:3}") ;;
          "flake metadata"*) command=(flake metadata --no-write-lock-file "''${@:3}") ;;
          "flake show"*) command=(flake show --no-write-lock-file "''${@:3}") ;;
          "store info") command=(store info) ;;
          "path-info "*) command=("$@") ;;
          *) printf 'unsupported command: %s\n' "$*" >&2; exit 64 ;;
        esac

        for argument in "''${command[@]}"; do
          if deny_argument "$argument"; then
            printf 'denied argument: %s\n' "$argument" >&2
            exit 2
          fi
        done

        exec ${getExe pkgs.nix} --option allow-import-from-derivation false "''${command[@]}"
      '';
    };
}
