{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.darwin-wm;
  flake.darwinModules.darwin-wm =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      system.defaults.NSGlobalDomain = {
        NSWindowShouldDragOnGesture = true;
        AppleEnableMouseSwipeNavigateWithScrolls = false;
        AppleEnableSwipeNavigateWithScrolls = false;

        AppleSpacesSwitchOnActivate = false;
      };

      system.defaults.CustomUserPreferences."com.apple.dock".workspaces-auto-swoosh = false;

      system.defaults.CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys =
        let
          inherit (lib.attrsets) getAttr mapAttrs;
          inherit (lib.fixedPoints) fix;
          inherit (lib.lists) foldl' singleton;
          inherit (lib.strings) charToInt;

          keyCodes =
            (
              {
                a = 0;
                b = 11;
                c = 8;
                d = 2;
                e = 14;
                f = 3;
                g = 5;
                h = 4;
                i = 34;
                j = 38;
                k = 40;
                l = 37;
                m = 46;
                n = 45;
                o = 31;
                p = 35;
                q = 12;
                r = 15;
                s = 1;
                t = 17;
                u = 32;
                v = 9;
                w = 13;
                x = 7;
                y = 16;
                z = 6;

                "1" = 18;
                "2" = 19;
                "3" = 20;
                "4" = 21;
                "5" = 23;
                "6" = 22;
                "7" = 26;
                "8" = 28;
                "9" = 25;
              }
              |> mapAttrs (
                char: code: {
                  char = charToInt char;
                  inherit code;
                }
              )
            )
            // {
              space = {
                char = 32;
                code = 49;
              };
              tab = {
                char = 65535;
                code = 48;
              };
              backspace = {
                char = 65535;
                code = 51;
              };
            };

          hotkey = key: modifiers: {
            enabled = 1;

            value.type = "standard";
            value.parameters = [
              keyCodes.${key}.char
              keyCodes.${key}.code
              (
                modifiers
                |> foldl' (
                  total: modifier:
                  total
                  + getAttr modifier (
                    fix (self: {
                      shift = 131072;
                      control = 262144;
                      option = 524288;
                      command = 1048576;

                      super = self.command + self.control;
                    })
                  )
                ) 0
              )
            ];
          };
        in
        {
          "28" = hotkey "s" [
            "super"
          ];
          "29" = hotkey "s" [
            "super"
            "option"
          ];

          "30" = hotkey "a" [
            "super"
          ];
          "31" = hotkey "a" [
            "super"
            "option"
          ];
          "184" = hotkey "a" [
            "super"
            "shift"
          ];

          "60" = hotkey "tab" [
            "super"
            "option"
            "shift"
          ];
          "61" = hotkey "tab" [
            "super"
            "option"
          ];

          "64" = hotkey "backspace" [
            "super"
          ];

          "7".enabled = 0;
          "8".enabled = 0;
          "9".enabled = 0;
          "10".enabled = 0;
          "11".enabled = 0;
          "12".enabled = 0;
          "13".enabled = 0;
          "27".enabled = 0;

          "15".enabled = 0;
          "17".enabled = 0;
          "19".enabled = 0;
          "21".enabled = 0;
          "23".enabled = 0;

          "25".enabled = 0;
          "26".enabled = 0;

          "32" = hotkey "o" [
            "super"
          ];

          "33".enabled = 0;
          "34".enabled = 0;
          "35".enabled = 0;

          "36".enabled = 0;
          "37".enabled = 0;

          "52".enabled = 0;

          "53".enabled = 0;
          "54".enabled = 0;

          "57".enabled = 0;

          "59".enabled = 0;

          "65".enabled = 0;

          "79" = hotkey "tab" [
            "super"
            "shift"
          ];
          "81" = hotkey "tab" [
            "super"
          ];

          "118" = hotkey "1" <| singleton "super";
          "119" = hotkey "2" <| singleton "super";
          "120" = hotkey "3" <| singleton "super";
          "121" = hotkey "4" <| singleton "super";
          "122" = hotkey "5" <| singleton "super";
          "123" = hotkey "6" <| singleton "super";
          "124" = hotkey "7" <| singleton "super";
          "125" = hotkey "8" <| singleton "super";
          "126" = hotkey "9" <| singleton "super";

          "80".enabled = 0;
          "82".enabled = 0;

          "98".enabled = 0;

          "156".enabled = 0;

          "159".enabled = 0;

          "162".enabled = 0;

          "164".enabled = 0;

          "181".enabled = 0;
          "182".enabled = 0;

          "190".enabled = 0;

          "233".enabled = 0;

          "237".enabled = 0;
          "238".enabled = 0;
          "239".enabled = 0;

          "240".enabled = 0;
          "241".enabled = 0;
          "242".enabled = 0;
          "243".enabled = 0;

          "248".enabled = 0;
          "249".enabled = 0;
          "250".enabled = 0;
          "251".enabled = 0;
        };

      system.activationScripts.postActivation.text =
        let
          inherit (lib.attrsets) mapAttrsToList;
          inherit (lib.lists) map optionals;
          inherit (lib.meta) getExe;
          inherit (lib.strings) toJSON;

          reload-symbolic-hotkey = pkgs.callPackage (
            { stdenv, writeText }:
            stdenv.mkDerivation {
              pname = "reload-symbolic-hotkey";
              version = "1.0.0";

              src = writeText "reload-symbolic-hotkey.c" /* c */ ''
                #include <stdbool.h>
                #include <stdint.h>
                #include <stdio.h>
                #include <stdlib.h>

                typedef int32_t CGError;
                typedef int32_t CGSSymbolicHotKey;
                typedef uint16_t CGKeyCode;
                typedef uint32_t CGSModifierFlags;
                typedef uint16_t unichar;

                extern CGError CGSSetSymbolicHotKeyEnabled(CGSSymbolicHotKey hotKey, bool enabled);
                extern CGError CGSSetSymbolicHotKeyValue(
                    CGSSymbolicHotKey hotKey,
                    unichar keyEquivalent,
                    CGKeyCode virtualKeyCode,
                    CGSModifierFlags modifiers);

                static uint32_t parseUint32(const char *value) {
                  char *end = NULL;
                  unsigned long parsed = strtoul(value, &end, 10);

                  if (end == value || *end != '\0' || parsed > UINT32_MAX) {
                    fprintf(stderr, "invalid integer: %s\n", value);
                    exit(2);
                  }

                  return (uint32_t)parsed;
                }

                int main(int argc, char **argv) {
                  if (argc != 3 && argc != 6) {
                    fprintf(stderr, "usage: %s <id> <enabled> [char keycode modifiers]\n", argv[0]);
                    return 2;
                  }

                  CGSSymbolicHotKey id = (CGSSymbolicHotKey)parseUint32(argv[1]);
                  bool enabled = parseUint32(argv[2]) != 0;

                  CGError value_error = 0;
                  if (argc == 6) {
                    unichar key_equivalent = (unichar)parseUint32(argv[3]);
                    CGKeyCode virtual_key_code = (CGKeyCode)parseUint32(argv[4]);
                    CGSModifierFlags modifiers = (CGSModifierFlags)parseUint32(argv[5]);
                    value_error = CGSSetSymbolicHotKeyValue(id, key_equivalent, virtual_key_code, modifiers);
                  }

                  CGError enabled_error = CGSSetSymbolicHotKeyEnabled(id, enabled);

                  return value_error == 0 && enabled_error == 0 ? 0 : 1;
                }
              '';

              dontUnpack = true;
              dontConfigure = true;

              buildPhase = /* bash */ ''
                $CC -O2 -Wall -Wextra \
                  -framework CoreGraphics \
                  -o reload-symbolic-hotkey $src
              '';

              installPhase = /* bash */ ''
                mkdir -p $out/bin
                install -m755 reload-symbolic-hotkey $out/bin/
              '';

              meta.mainProgram = "reload-symbolic-hotkey";
            }
          ) { };
        in
        "${pkgs.writers.writeNu "reload-symbolic-hotkeys.nu" /* nu */ ''
          print "reloading symbolic hotkeys..."

          let user = r###'${config.system.primaryUser}'###
          let uid = sys users | where name == $user | get 0.id

          ^/bin/launchctl asuser $uid /usr/bin/sudo --set-home --user $user -- ${
            pkgs.writers.writeNu "reload-symbolic-hotkeys-peruser.nu" /* nu */ ''
              let hotkeys = r###'${
                config.system.defaults.CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys
                |> mapAttrsToList (
                  id:
                  {
                    enabled,
                    value ? null,
                  }:
                  [
                    id
                    (toString enabled)
                  ]
                  ++ optionals (value != null) (map toString value.parameters)
                )
                |> toJSON
              }'### | from json

              for hotkey in $hotkeys {
                ^${getExe reload-symbolic-hotkey} ...$hotkey
              }
            ''
          }
        ''}";

      system.defaults.CustomUserPreferences."com.apple.AppleMultitouchTrackpad" = {
        TrackpadThreeFingerVertSwipeGesture = 0;

        TrackpadFourFingerHorizSwipeGesture = 0;
        TrackpadThreeFingerHorizSwipeGesture = 0;
      };

      system.defaults.WindowManager = {
        AppWindowGroupingBehavior = false;
      };
    };
}
