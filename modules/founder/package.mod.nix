{ ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      packages.founder = pkgs.callPackage (
        {
          stdenvNoCC,
          fetchurl,
          unzip,
        }:
        stdenvNoCC.mkDerivation {
          pname = "founder";
          version = "0.1.0-unstable-2026-11-12";

          src = fetchurl {
            url = "https://api.github.com/repos/Cafekery/NativeGPUI/releases/assets/737653753";
            name = "Founder.zip";
            curlOptsList = [
              "--header"
              "Accept: application/octet-stream"
            ];
            hash = "sha256-+IExpMiyN6JeZbSIzxuuuxBe3dzDx5XrHpJQ+BJronA=";
          };

          nativeBuildInputs = singleton unzip;

          sourceRoot = ".";
          dontConfigure = true;
          dontBuild = true;
          dontFixup = true;

          installPhase = /* bash */ ''
            runHook preInstall
            mkdir -p "$out/Applications"
            cp -R "Found'er.app" "$out/Applications/"
            runHook postInstall
          '';

          meta = {
            description = "NativeGPUI file browser with native AppKit controls";
            homepage = "https://github.com/Cafekery/NativeGPUI";
            license = lib.licenses.mit;
            platforms = singleton "aarch64-darwin";
          };
        }
      ) { };
    };
}
