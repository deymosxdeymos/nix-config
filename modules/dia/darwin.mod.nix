{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.dia;
  flake.darwinModules.dia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.strings) escapeShellArg;

      package = self.packages.${pkgs.stdenv.hostPlatform.system}.diatweaks;

      patchDia = pkgs.writeShellScript "patch-dia" /* bash */ ''
        set -o errexit -o nounset

        support="$HOME/Library/Application Support/DiaPatches"
        incoming="$support/.incoming"
        app=/Applications/Dia.app
        stamp="$support/nix-build"

        if [ ! -d "$app" ]; then
          exit 0
        fi

        patched=$(/usr/libexec/PlistBuddy -c "Print :DiaPatches" "$app/Contents/Info.plist" 2>/dev/null || true)

        if [ "$patched" = true ] && [ "$(/bin/cat "$stamp" 2>/dev/null || true)" = ${package} ]; then
          exit 0
        fi

        /bin/rm -rf "$incoming"
        /bin/mkdir -p "$incoming" "$support/bin"
        /bin/cp ${package}/bin/diapatch ${package}/bin/diatweaks ${package}/lib/DiaPatches.dylib ${package}/share/diatweaks/patches.json "$incoming/"
        /bin/cp -R ${package}/share/diatweaks/app-icons "$incoming/"
        /bin/chmod -R u+w "$incoming"
        /bin/mv -f "$incoming/diapatch" "$incoming/diatweaks" "$support/bin/"
        /bin/mv -f "$incoming/DiaPatches.dylib" "$incoming/patches.json" "$support/"
        /bin/rm -rf "$support/app-icons" "$support/release.plist"
        /bin/mv -f "$incoming/app-icons" "$support/"
        /bin/rm -rf "$incoming"

        "$support/bin/diapatch" install

        echo ${package} > "$stamp"
      '';
    in
    {
      environment.systemPackages = singleton package;

      homebrew.casks = singleton "thebrowsercompany-dia";

      system.activationScripts.postActivation.text = /* bash */ ''
        echo "patching dia..."
        /bin/launchctl asuser "$(/usr/bin/id -u ${escapeShellArg config.system.primaryUser})" \
          /usr/bin/sudo --user=${escapeShellArg config.system.primaryUser} --set-home -- ${patchDia} \
          || echo "warning: diatweaks failed to patch dia" >&2
      '';
    };
}
