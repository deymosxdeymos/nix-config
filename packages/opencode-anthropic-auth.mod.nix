{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      inherit (lib.licenses) mit;
      inherit (lib.platforms) all;
    in
    {
      packages.opencode-anthropic-auth = pkgs.callPackage (
        { fetchurl, stdenvNoCC }:
        stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "opencode-anthropic-auth";
          version = "1.8.1";

          src = fetchurl {
            url = "https://registry.npmjs.org/@ex-machina/opencode-anthropic-auth/-/opencode-anthropic-auth-${finalAttrs.version}.tgz";
            hash = "sha256-30rIFuAjFSRiJ+AVvNk6LiqUMb79FPwK+5tllMFNqkg=";
          };

          dontBuild = true;

          installPhase = /* bash */ ''
            runHook preInstall

            mkdir --parents "$out"
            cp --recursive ./* "$out/"

            runHook postInstall
          '';

          meta = {
            description = "OpenCode plugin for Anthropic OAuth authentication";
            homepage = "https://github.com/ex-machina-co/opencode-anthropic-auth";
            license = mit;
            platforms = all;
          };
        })
      ) { };
    };
}
