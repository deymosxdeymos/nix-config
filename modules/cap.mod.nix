{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.cap;
  flake.darwinModules.cap =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.attrsets) genAttrs;
      inherit (lib.lists) elem singleton;
      inherit (lib.modules) mkForce;
      inherit (lib.strings) toJSON;

      hotkey = code: modifiers: {
        inherit code;
        meta = elem "command" modifiers;
        ctrl = elem "control" modifiers;
        alt = elem "option" modifiers;
        shift = elem "shift" modifiers;
      };

      hotkeys = {
        screenshotDisplay = hotkey "KeyS" [
          "command"
          "control"
        ];
        screenshotArea = hotkey "KeyA" [
          "command"
          "control"
        ];
        openRecordingPicker = hotkey "KeyA" [
          "command"
          "control"
          "shift"
        ];

        startStudioRecording = hotkey "KeyR" [
          "command"
          "control"
        ];
        stopRecording = hotkey "KeyR" [
          "command"
          "control"
          "shift"
        ];
      };
    in
    {
      homebrew.casks = singleton "cap";

      system.defaults.CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys =
        genAttrs
          [
            "28"
            "29"
            "30"
            "31"
            "184"
          ]
          (_: {
            enabled = mkForce 0;
          });

      system.activationScripts.postActivation.text = "${pkgs.writers.writeNu "cap-hotkeys.nu" /* nu */ ''
        print "setting cap hotkeys..."

        let user = r###'${config.system.primaryUser}'###
        let uid = sys users | where name == $user | get 0.id

        ^/bin/launchctl asuser $uid /usr/bin/sudo --set-home --user $user -- ${
          pkgs.writers.writeNu "cap-hotkeys-peruser.nu" /* nu */ ''
            let hotkeys = r###'${toJSON hotkeys}'### | from json

            let directory = $env.HOME | path join "Library/Application Support/so.cap.desktop"
            let path = $directory | path join "store"

            mkdir $directory

            let store = if ($path | path exists) { open --raw $path | from json } else { {} }

            $store | upsert hotkeys { hotkeys: $hotkeys } | to json | save --force $path
          ''
        }
      ''}";
    };
}
