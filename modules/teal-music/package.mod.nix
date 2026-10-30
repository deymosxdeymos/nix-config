{
  perSystem =
    { lib, pkgs, ... }:
    let
      inherit (lib.meta) getExe;
    in
    {
      packages.teal-music = pkgs.writeShellApplication {
        name = "teal-music";
        text = /* bash */ ''
          exec ${getExe pkgs.python3} ${./tracker.py} --music-script ${./music.js} "$@"
        '';
      };

      checks.teal-music = pkgs.runCommand "teal-music-tests" { } /* bash */ ''
        ${getExe pkgs.python3} ${./tracker_test.py} ${./tracker.py}
        touch "$out"
      '';
    };
}
