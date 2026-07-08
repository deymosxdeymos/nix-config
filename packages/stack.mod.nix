{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      inherit (lib.licenses) mit;
    in
    {
      packages.stack = pkgs.callPackage (
        {
          stdenvNoCC,
          bun,
          nodejs,
          makeWrapper,
          fetchFromGitHub,
        }:
        let
          version = "0.4.2-jj";

          src = fetchFromGitHub {
            owner = "deymosxdeymos";
            repo = "stack";
            rev = "0d6665229e63fc6e58bf7016d0ef382f325ac948";
            hash = "sha256-CSJBADVO2f5tZvqVeJAc+qjnlJdD+C5Sgoikpvaq38Y=";
          };

          nodeModules = stdenvNoCC.mkDerivation {
            pname = "stack-node-modules";
            inherit version src;

            nativeBuildInputs = [ bun ];

            dontConfigure = true;

            buildPhase = /* bash */ ''
              runHook preBuild

              export HOME="$TMPDIR"
              export BUN_INSTALL_CACHE_DIR="$TMPDIR/bun-cache"
              bun install --frozen-lockfile --no-progress

              runHook postBuild
            '';

            installPhase = /* bash */ ''
              runHook preInstall

              rm --recursive --force node_modules/.cache
              mkdir --parents "$out"
              cp --recursive node_modules "$out/node_modules"

              runHook postInstall
            '';

            dontFixup = true;

            outputHashMode = "recursive";
            outputHashAlgo = "sha256";
            outputHash = "sha256-T9uJg/c0UaJF7l8CYCsia7DC8dy1YvK/8h/hx14TBaU=";
          };
        in
        stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "stack";
          inherit version src;

          nativeBuildInputs = [
            bun
            makeWrapper
            nodejs
          ];

          buildPhase = /* bash */ ''
            runHook preBuild

            export HOME="$TMPDIR"
            cp --recursive "${nodeModules}/node_modules" ./node_modules
            chmod --recursive u+w node_modules
            bun run dev/build-cli.ts

            runHook postBuild
          '';

          installPhase = /* bash */ ''
            runHook preInstall

            mkdir --parents "$out/bin" "$out/share/stack"
            cp dist/cli.js "$out/share/stack/cli.js"
            makeWrapper "${lib.getExe nodejs}" "$out/bin/stack" \
              --add-flags "$out/share/stack/cli.js"

            runHook postInstall
          '';

          meta = {
            description = "Squash-safe stacked PR/MR repair CLI with native jj support";
            homepage = "https://github.com/deymosxdeymos/stack";
            license = mit;
            mainProgram = "stack";
          };
        })
      ) { };
    };
}
