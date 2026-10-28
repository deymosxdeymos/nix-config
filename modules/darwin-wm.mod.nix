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
      # NSGLOBALDOMAIN
      system.defaults.NSGlobalDomain = {
        NSWindowShouldDragOnGesture = true; # CMD+CTRL click to drag window. PaperWM intercepts this for tiled windows.
        AppleEnableMouseSwipeNavigateWithScrolls = false;
        AppleEnableSwipeNavigateWithScrolls = false;

        NSWindowResizeTime = 0.003;

        AppleSpacesSwitchOnActivate = false; # Do not switch workspaces implicitly.
      };

      # DOCK
      system.defaults.CustomUserPreferences."com.apple.dock".workspaces-auto-swoosh = false;

      # HOTKEYS
      # Only the Spotlight hotkeys are touched, so Raycast can take CMD+SPACE.
      # Merged with `-dict-add` rather than replacing every symbolic hotkey.
      system.activationScripts.postActivation.text =
        let
          inherit (lib.meta) getExe;

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

                extern CGError CGSSetSymbolicHotKeyEnabled(CGSSymbolicHotKey hotKey, bool enabled);

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
                  if (argc != 3) {
                    fprintf(stderr, "usage: %s <id> <enabled>\n", argv[0]);
                    return 2;
                  }

                  CGSSymbolicHotKey id = (CGSSymbolicHotKey)parseUint32(argv[1]);
                  bool enabled = parseUint32(argv[2]) != 0;

                  return CGSSetSymbolicHotKeyEnabled(id, enabled) == 0 ? 0 : 1;
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
        /* bash */ ''
          echo "disabling spotlight hotkeys..."

          uid=$(/usr/bin/id -u ${config.system.primaryUser})

          # 64: Spotlight search. 65: Finder search window.
          for id in 64 65; do
            /bin/launchctl asuser "$uid" /usr/bin/sudo --set-home --user ${config.system.primaryUser} -- \
              /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
              -dict-add "$id" '{ enabled = 0; }'

            /bin/launchctl asuser "$uid" /usr/bin/sudo --set-home --user ${config.system.primaryUser} -- \
              ${getExe reload-symbolic-hotkey} "$id" 0
          done
        '';

      # TRACKPAD
      system.defaults.CustomUserPreferences."com.apple.AppleMultitouchTrackpad" = {
        TrackpadThreeFingerVertSwipeGesture = 0; # Four finger swipe up for mission control.

        # Disable 3 finger horizontal stuff, PaperWM uses it to scroll.
        TrackpadFourFingerHorizSwipeGesture = 0;
        TrackpadThreeFingerHorizSwipeGesture = 0;
      };

      # WINDOW MANAGER
      system.defaults.WindowManager = {
        AppWindowGroupingBehavior = false; # Show them one at a time.
      };
    };

  flake.homeModules.default = self.homeModules.darwin-wm;
  flake.homeModules.darwin-wm =
    {
      lib,
      osConfig,
      pkgs,
      ...
    }:
    let
      inherit (lib.meta) getExe;
      inherit (lib.modules) mkAfter;
    in
    {
      # SPOONS
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

      # INIT
      xdg.config.files."hammerspoon/init.lua".text = mkAfter /* lua */ ''
        ---@type table
        _G.hs = _G.hs

        PaperWM = hs.loadSpoon("PaperWM")
        Swipe = hs.loadSpoon("Swipe")

        local space_task = nil

        local changeSpaceBy = function(offset)
          if offset == 0 then return end

          if space_task and space_task:isRunning() then
            space_task:terminate()
          end

          space_task = hs.task.new("${
            getExe self.packages.${osConfig.nixpkgs.hostPlatform.system}.fast-workspace-switch
          }", nil, {
            offset > 0 and "right" or "left",
            tostring(math.abs(offset)),
          })

          space_task:start()
        end

        local gotoSpace = function(index)
          local current_index = (function()
            local current_space = hs.spaces.activeSpaceOnScreen()
            local spaces = hs.spaces.allSpaces()[hs.screen.mainScreen():getUUID()]

            local current_index = nil
            for space_index, space in ipairs(spaces) do
              if space == current_space then
                current_index = space_index
                break
              end
            end

            return current_index
          end)()
          local change_by = index - current_index

          changeSpaceBy(change_by)
        end

        -- Bind both the arrow and the vim key for a direction.
        local bindDirection = function(modifiers, direction, fn)
          local vim_key = ({ left = "h", down = "j", up = "k", right = "l" })[direction]

          hs.hotkey.bind(modifiers, direction, fn)
          hs.hotkey.bind(modifiers, vim_key, fn)
        end

        do -- HOTKEYS
          local super = { "cmd", "ctrl" }
          local super_alt = { "cmd", "ctrl", "alt" }
          local super_shift = { "cmd", "ctrl", "shift" }

          local actions = PaperWM.actions.actions()

          -- SPACES
          hs.hotkey.bind(super, "tab", function() changeSpaceBy(1) end)
          hs.hotkey.bind(super_shift, "tab", function() changeSpaceBy(-1) end)

          for index = 1, 9 do
            hs.hotkey.bind(super, tostring(index), function() gotoSpace(index) end)
            hs.hotkey.bind(super_shift, tostring(index), actions["move_window_" .. index])
          end

          -- FOCUS
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

          -- RESIZE
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

          -- SWAP / MOVE
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

          -- SLURP & BARF
          hs.hotkey.bind(super_shift, "t", actions.slurp_in)
          hs.hotkey.bind(super_shift, "g", actions.barf_out)

          -- MISC
          hs.hotkey.bind(super, "q", function()
            local window = hs.window.focusedWindow()
            if not window then return end
            window:close()
          end)
          hs.hotkey.bind(super, "c", actions.center_window)
          hs.hotkey.bind(super, "f", actions.toggle_floating)

          -- APPLICATIONS
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
          PaperWM.swipe_gain = 1.7

          -- FALL BACK TO SYSTEM WINDOW GRAB ON FLOATING
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

          -- FLOATING WINDOWS ON TOP
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

        do -- 3 FINGER VERTICAL SWIPE TO CHANGE SPACES
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

        do -- SPACE BUTTONS
          local space_buttons = {}

          local updateSpaceButtons = function()
            local current_space = hs.spaces.activeSpaceOnScreen()
            local spaces = hs.spaces.allSpaces()[hs.screen.mainScreen():getUUID()]

            if #space_buttons ~= #spaces then
              for _, button in pairs(space_buttons) do
                button:delete()
              end
              space_buttons = {}

              for index = #spaces, 1, -1 do
                space_buttons[index] = hs.menubar.new()

                space_buttons[index]:setClickCallback(function()
                  gotoSpace(index)
                end)
              end
            end

            for index, space in ipairs(spaces) do
              local attributes = space == current_space and {
                color = { red = 1 }
              } or {}

              space_buttons[index]:setTitle(hs.styledtext.new(tostring(index), attributes))
            end
          end

          hs.spaces.watcher.new(updateSpaceButtons):start()

          updateSpaceButtons()
        end

        do -- NO ANIMATIONS
          hs.window.animationDuration = 0
        end
      '';
    };
}
