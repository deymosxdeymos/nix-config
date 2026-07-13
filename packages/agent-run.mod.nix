{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      inherit (lib.licenses) gpl3Only;
      inherit (lib.platforms) linux;
    in
    {
      packages.agent-run = pkgs.callPackage (
        {
          rustPlatform,
          fetchFromGitHub,
          bubblewrap,
        }:
        rustPlatform.buildRustPackage (finalAttrs: {
          pname = "agent-run";
          version = "0.1.1";

          src = fetchFromGitHub {
            owner = "sin-ack";
            repo = "agent-run";
            tag = "v${finalAttrs.version}";
            hash = "sha256-ewjsyykAtO+ZbXJwAlsrGno/P55GuQ0UnYjtyC+nkRU=";
          };

          cargoHash = "sha256-frAMLXWzYbsUgEl3OpK9dhTdaMnZolY0WRkKulTmFlY=";

          buildFeatures = [ "external-bwrap" ];

          env.BUBBLEWRAP_PATH = "${bubblewrap}/bin/bwrap";

          # The integration tests require nested user namespaces and PTYs,
          # which are not reliably available on Nix builders.
          doCheck = false;

          strictDeps = true;

          meta = {
            description = "Run a coding agent in a sandboxed environment";
            homepage = "https://github.com/sin-ack/agent-run";
            license = gpl3Only;
            mainProgram = "agent-run";
            platforms = linux;
          };
        })
      ) { };
    };
}
