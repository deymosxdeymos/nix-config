{ self, ... }:
{
  perSystem =
    { lib, pkgs, ... }:
    let
      inherit (lib.meta) getExe;
    in
    {
      packages.default = pkgs.writeScriptBin "nh" /* bash */ ''
        #!${getExe pkgs.bash}
        export NH_FLAKE="${self}"
        exec ${getExe pkgs.nh} "$@"
      '';
    };
}
