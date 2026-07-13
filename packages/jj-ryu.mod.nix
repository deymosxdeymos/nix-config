{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      inherit (lib.licenses) mit;
    in
    {
      packages.jj-ryu = pkgs.callPackage (
        {
          rustPlatform,
          fetchFromGitHub,
        }:
        rustPlatform.buildRustPackage (finalAttrs: {
          pname = "jj-ryu";
          version = "0.0.1-alpha.11";

          src = fetchFromGitHub {
            owner = "dmmulroy";
            repo = "jj-ryu";
            tag = "v${finalAttrs.version}";
            hash = "sha256-gE4lvqyC2LRAWNDUGePklORWjyEofs/dHLHVBAub424=";
          };

          cargoHash = "sha256-OD1DpV4s6tgOnDEAfJWScdSKqtYArbqIJVClOtUCYa4=";

          # Network-dependent end-to-end tests are gated behind `#[ignore]`, but
          # the remaining suite still expects a jj workspace; skip tests here.
          doCheck = false;

          meta = {
            description = "Stacked PRs for Jujutsu with GitHub/GitLab support";
            homepage = "https://github.com/dmmulroy/jj-ryu";
            license = mit;
            mainProgram = "ryu";
          };
        })
      ) { };
    };
}
