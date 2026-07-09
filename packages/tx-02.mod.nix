{ inputs, lib, ... }:
{
  perSystem =
    { system, ... }:
    let
      inherit (lib.licenses) unfree;

      # self.packages is built by flake-parts' perSystem nixpkgs, which does not
      # inherit the NixOS-level allowUnfree. TX-02 is unfree, so build it with a
      # nixpkgs instance that permits it.
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # TX-02 is Berkeley Mono, a proprietary typeface. The `.otf` files are
      # vendored under ./tx-02 because it is not distributable via a fetcher.
      packages.tx-02 = pkgs.callPackage (
        { stdenvNoCC }:
        stdenvNoCC.mkDerivation {
          pname = "tx-02";
          version = "1.0";

          src = ./tx-02;

          dontConfigure = true;
          dontBuild = true;

          installPhase = /* bash */ ''
            runHook preInstall

            mkdir --parents "$out/share/fonts/opentype"
            cp ./*.otf "$out/share/fonts/opentype/"

            runHook postInstall
          '';

          meta = {
            description = "TX-02 (Berkeley Mono) monospace typeface";
            license = unfree;
          };
        }
      ) { };
    };
}
