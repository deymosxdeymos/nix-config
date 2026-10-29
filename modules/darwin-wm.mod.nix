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

  flake.homeModules.default = self.homeModules.darwin-wm;
  flake.homeModules.darwin-wm =
    { lib, pkgs, ... }:
    let
      inherit (lib.modules) mkAfter;
    in
    {
      xdg.config.files."hammerspoon/Spoons/PaperWM.spoon".source = pkgs.fetchFromGitHub {
        owner = "mogenson";
        repo = "PaperWM.spoon";
        rev = "34787bf38ce429a84f94ae00a73418e32cc1abb8";
        hash = "sha256-hffz5Ae/INkYXRgZVX4FNejCbqC1l1aTigFRDFe8cYM=";
      };

      xdg.config.files."hammerspoon/Spoons/Swipe.spoon".source = pkgs.fetchFromGitHub {
        owner = "mogenson";
        repo = "Swipe.spoon";
        rev = "c56520507d98e663ae0e1228e41cac690557d4aa";
        hash = "sha256-G0kuCrG6lz4R+LdAqNWiMXneF09pLI+xKCiagryBb5k=";
      };

      xdg.config.files."hammerspoon/init.lua".text = mkAfter /* lua */ ''
        _G.hs = _G.hs

        require("hs.ipc")

        PaperWM = hs.loadSpoon("PaperWM")
        Swipe = hs.loadSpoon("Swipe")

        local changeSpaceBy = function(offset)
          hs.eventtap.keyStroke(offset > 0 and { "cmd", "ctrl" } or { "cmd", "ctrl", "shift" }, "tab", 0)
        end

        local moveWindowToSpace = function(index)
          local window = hs.window.focusedWindow()
          if not window then return end

          local frame = window:frame()
          local point = { x = frame.x + frame.w / 2, y = frame.y + 10 }

          local zoom = hs.axuielement.windowElement(window):attributeValue("AXZoomButton")
          if zoom then
            local button = zoom:attributeValue("AXFrame")
            point = { x = button.x + button.w + 12, y = button.y + button.h / 2 }
          end

          local tiled = PaperWM.state.windowIndex(window) ~= nil
          if tiled then PaperWM.floating.toggleFloating(window) end

          local mouse = hs.mouse.absolutePosition()
          hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, point):post()

          hs.timer.doAfter(0.15, function()
            hs.eventtap.keyStroke({ "cmd", "ctrl" }, tostring(index), 0)

            hs.timer.doAfter(0.5, function()
              hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, point):post()
              hs.mouse.absolutePosition(mouse)

              if tiled then
                hs.timer.doAfter(0.3, function() PaperWM.floating.toggleFloating(window) end)
              end
            end)
          end)
        end

        local bindDirection = function(modifiers, direction, fn)
          local vim_key = ({ left = "h", down = "j", up = "k", right = "l" })[direction]

          hs.hotkey.bind(modifiers, direction, fn)
          hs.hotkey.bind(modifiers, vim_key, fn)
        end

        do
          local super = { "cmd", "ctrl" }
          local super_alt = { "cmd", "ctrl", "alt" }
          local super_shift = { "cmd", "ctrl", "shift" }

          local actions = PaperWM.actions.actions()

          for index = 1, 9 do
            hs.hotkey.bind(super_shift, tostring(index), function() moveWindowToSpace(index) end)
          end

          PaperWM.drag_window = super
          bindDirection(super, "left", function()
            actions.focus_left()
            actions.center_window()
          end)
          bindDirection(super, "down", actions.focus_down)
          bindDirection(super, "up", actions.focus_up)
          bindDirection(super, "right", function()
            actions.focus_right()
            actions.center_window()
          end)

          do
            local windowResize = function(offsetWidth, offsetHeight)
              local window = hs.window.focusedWindow()
              if not window then return end

              local frame = window:frame()
              local screen_frame = window:screen():frame()

              frame.w = math.max(100, math.min(frame.w + offsetWidth, screen_frame.x2 - frame.x))
              frame.h = math.max(100, math.min(frame.h + offsetHeight, screen_frame.y2 - frame.y))

              window:setFrame(frame)
            end

            local columnRightBorderMove = function(offset)
              local window = hs.window.focusedWindow()
              if not window then return end

              local index = PaperWM.state.windowIndex(window)
              if not index then
                windowResize(offset, 0)
                return
              end

              local canvas = PaperWM.windows.getCanvas(window:screen())

              local frame = window:frame()
              frame.w = math.max(100, math.min(frame.w + offset, canvas.w))

              PaperWM.windows.moveWindow(window, frame)
              PaperWM:tileSpace(index.space, window)
            end

            local dividerMove = function(offset)
              local window = hs.window.focusedWindow()
              if not window then return end

              local index = PaperWM.state.windowIndex(window)
              if not index then
                windowResize(0, offset)
                return
              end

              local column = PaperWM.state.windowList(index.space, index.col)
              if not column or #column == 1 then return end

              local above = index.row < #column and window or column[index.row - 1]

              local canvas = PaperWM.windows.getCanvas(window:screen())

              local frame = above:frame()
              frame.h = math.max(100, math.min(frame.h + offset, canvas.y2 - 100 - frame.y))

              PaperWM.windows.moveWindow(above, frame)
              PaperWM:tileSpace(index.space, above)
            end

            bindDirection(super_alt, "left", function()  columnRightBorderMove(-100) end)
            bindDirection(super_alt, "down", function()            dividerMove( 100) end)
            bindDirection(super_alt, "up", function()              dividerMove(-100) end)
            bindDirection(super_alt, "right", function() columnRightBorderMove( 100) end)
          end

          hs.hotkey.bind(super_alt, "f", actions.full_width)

          do
            PaperWM.lift_window = super_shift

            local swapOrMove = function(swap, offsetX, offsetY) return function()
              local window = hs.window.focusedWindow()
              if not window then return end

              if PaperWM.state.windowIndex(window) then
                swap()
                return
              end

              local frame = window:frame()
              window:setTopLeft({ x = frame.x + offsetX, y = frame.y + offsetY })
            end end

            bindDirection(super_shift, "left", swapOrMove(actions.swap_left, -100,    0))
            bindDirection(super_shift, "down", swapOrMove(actions.swap_down,    0,  100))
            bindDirection(super_shift, "up", swapOrMove(actions.swap_up,        0, -100))
            bindDirection(super_shift, "right", swapOrMove(actions.swap_right, 100,   0))
          end

          hs.hotkey.bind(super_shift, "t", actions.slurp_in)
          hs.hotkey.bind(super_shift, "g", actions.barf_out)

          hs.hotkey.bind(super, "q", function()
            local window = hs.window.focusedWindow()
            if not window then return end
            window:close()
          end)
          hs.hotkey.bind(super, "c", actions.center_window)
          hs.hotkey.bind(super, "f", actions.toggle_floating)

          hs.hotkey.bind(super, "w", function() hs.application.launchOrFocus("Helium") end)
          hs.hotkey.bind(super, "return", function()
            local rex = hs.application.get("Rex Beta")

            if not rex then
              hs.application.launchOrFocus("Rex Beta")
              return
            end

            rex:activate()
            hs.eventtap.keyStroke({ "cmd" }, "n", 0, rex)
          end)
          hs.hotkey.bind(super, "t", function() hs.application.launchOrFocus("Finder") end)

          PaperWM.swipe_fingers = 3
          PaperWM.swipe_gain = 1

          do
            local mouseHandler = PaperWM.events.mouseHandler

            PaperWM.events.mouseHandler = function(wm)
              local handler = mouseHandler(wm)

              return function(event)
                local drag_click = event:getType() == hs.eventtap.event.types.leftMouseDown
                  and (event:getFlags():containExactly(super) or event:getFlags():containExactly(super_shift))
                if not drag_click then return handler(event) end

                local cursor = hs.geometry.new(event:location())
                for _, window in ipairs(hs.window.orderedWindows()) do
                  if cursor:inside(window:frame()) then
                    if not wm.state.windowIndex(window) then return false end
                    break
                  end
                end

                return handler(event)
              end
            end
          end

          PaperWM.window_filter:subscribe({
            hs.window.filter.windowFocused,
            hs.window.filter.windowVisible,
          }, function(window)
            if not PaperWM.state.windowIndex(window) then return end

            for id in pairs(PaperWM.state.is_floating) do
              local floating = hs.window.get(id)
              if floating then floating:raise() end
            end
          end)

          PaperWM:start()
        end

        do
          local current_id, threshold

          Swipe:start(3, function(direction, distance, id)
            if id ~= current_id then
              current_id = id
              threshold = 0.2
              return
            end

            if distance > threshold then
              threshold = math.huge

              if direction == "up" then
                changeSpaceBy(1)
              elseif direction == "down" then
                changeSpaceBy(-1)
              end
            end
          end)
        end
      '';
    };
}
