{ inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      packages.diatweaks = pkgs.callPackage (
        {
          apple-sdk_26,
          rustPlatform,
          swift,
        }:
        rustPlatform.buildRustPackage {
          pname = "diatweaks";
          version = "0-unstable-${inputs.diatweaks.lastModifiedDate}";

          src = inputs.diatweaks;

          cargoRoot = "cli";
          buildAndTestSubdir = "cli";
          cargoLock.lockFile = "${inputs.diatweaks}/cli/Cargo.lock";

          nativeBuildInputs = singleton swift;

          buildInputs = singleton apple-sdk_26;

          postPatch = /* bash */ ''
            substituteInPlace cli/build.rs \
              --replace-fail '"unknown".into()' '"${inputs.diatweaks.rev}".into()'

            substituteInPlace src/diapatch/Passkeys.m \
              --replace-fail 'static NSArray<NSString *> *const kAccountStore = @[' '#define kAccountStore @[' \
              --replace-fail '@"global_key_value_store.db-shm" ];' '@"global_key_value_store.db-shm" ]'
          '';

          postBuild = /* bash */ ''
            make SDK="$SDKROOT" COMMIT=${inputs.diatweaks.rev}
          '';

          postInstall = /* bash */ ''
            install -Dm755 build/diapatch "$out/bin/diapatch"
            install -Dm755 build/DiaPatches.dylib "$out/lib/DiaPatches.dylib"
            install -Dm644 build/patches.json "$out/share/diatweaks/patches.json"
            cp -R assets/app-icons "$out/share/diatweaks/app-icons"
          '';

          doCheck = false;
          dontStrip = true;

          meta = {
            mainProgram = "diatweaks";
            platforms = singleton "aarch64-darwin";
          };
        }
      ) { };
    };
}
