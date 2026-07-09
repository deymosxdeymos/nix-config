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
      # Each face is patched with Nerd Fonts glyphs so the typeface carries the
      # icons itself (no fallback font); the patcher appends " Nerd Font" to
      # every family name (e.g. "TX-02 SemiCondensed Nerd Font").
      packages.tx-02 = pkgs.callPackage (
        { stdenvNoCC, nerd-font-patcher }:
        stdenvNoCC.mkDerivation {
          pname = "tx-02-nerd";
          version = "1.0";

          src = ./tx-02;

          nativeBuildInputs = [ nerd-font-patcher ];

          dontConfigure = true;

          buildPhase = /* bash */ ''
            runHook preBuild

            export HOME="$TMPDIR"
            mkdir --parents patched
            # `--name filename` keeps each width/weight a distinct family named
            # after its source file; without it the patcher collapses every face
            # to "TX02 Nerd Font Regular" and they clobber each other on output.
            printf '%s\n' ./*.otf | xargs \
              --max-procs "$NIX_BUILD_CORES" --replace={} \
              nerd-font-patcher --complete --quiet --name filename \
              --outputdir patched {}

            runHook postBuild
          '';

          installPhase = /* bash */ ''
            runHook preInstall

            mkdir --parents "$out/share/fonts/opentype"
            cp ./patched/*.otf "$out/share/fonts/opentype/"

            runHook postInstall
          '';

          meta = {
            description = "TX-02 (Berkeley Mono), patched with Nerd Fonts glyphs";
            license = unfree;
          };
        }
      ) { };
    };
}
