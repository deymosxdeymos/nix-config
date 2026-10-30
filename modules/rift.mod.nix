{ inputs, self, ... }:
{
  flake.darwinModules.default = self.darwinModules.rift;
  flake.darwinModules.rift =
    { lib, ... }:
    let
      inherit (lib.attrsets) genAttrs;
      inherit (lib.lists) singleton;
      inherit (lib.modules) mkForce;
    in
    {
      homebrew.brews = singleton "acsandmann/tap/rift";

      nix-homebrew.taps."acsandmann/homebrew-tap" = inputs.homebrew-rift;
      nix-homebrew.trust.formulae = singleton "acsandmann/tap/rift";

      system.defaults.spaces.spans-displays = false;

      system.defaults.CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys =
        genAttrs
          [
            "32"
            "79"
            "81"
            "118"
            "119"
            "120"
            "121"
            "122"
            "123"
            "124"
            "125"
            "126"
          ]
          (_: {
            enabled = mkForce 0;
          });

      launchd.user.agents.rift.serviceConfig = {
        ProgramArguments = singleton "/opt/homebrew/bin/rift";
        RunAtLoad = true;
        KeepAlive = true;
        ProcessType = "Interactive";
        StandardOutPath = "/tmp/rift.out.log";
        StandardErrorPath = "/tmp/rift.err.log";
      };
    };

  flake.homeModules.default = self.homeModules.rift;
  flake.homeModules.rift =
    { lib, pkgs, ... }:
    let
      inherit (lib.attrsets) listToAttrs nameValuePair;
      inherit (lib.lists) concatMap range;
    in
    {
      xdg.config.files."rift/config.toml".source = (pkgs.formats.toml { }).generate "rift-config.toml" {
        settings = {
          animate = true;
          animation_duration = 0.3;
          animation_fps = 60.0;
          default_disable = false;
          focus_follows_mouse = false;
          mouse_follows_focus = false;
          hot_reload = true;

          layout = {
            mode = "scrolling";
            gaps = {
              outer = {
                top = 8;
                bottom = 8;
                left = 8;
                right = 8;
              };
              inner = {
                horizontal = 8;
                vertical = 8;
              };
            };
            scrolling = {
              column_width_ratio = 0.7;
              max_column_width_ratio = 1.0;
              alignment = "center";
              focus_navigation_style = "niri";
              gestures = {
                enabled = true;
                invert_horizontal = true;
                fingers = 3;
              };
            };
          };

          drag_drop.modifier = "Meta + Ctrl";

          ui.mission_control.enabled = true;
          ui.menu_bar = {
            enabled = true;
            display_style = "label";
            mode = "active";
          };
        };

        virtual_workspaces = {
          enabled = true;
          default_workspace_count = 9;
          preserve_focus_per_workspace = true;
        };

        keys = {
          "Meta + Ctrl + Tab" = "next_workspace";
          "Meta + Ctrl + Shift + Tab" = "prev_workspace";
          "Meta + Ctrl + C" = "center_selection";
          "Meta + Ctrl + F" = "toggle_window_floating";
          "Meta + Ctrl + Alt + F" = "toggle_fullscreen";
          "Meta + Ctrl + Q" = "close_window";
          "Meta + Ctrl + O" = "show_mission_control_all";
          "Meta + Ctrl + Shift + T".join_window = "left";
          "Meta + Ctrl + Shift + G" = "unjoin_windows";
          "Meta + Ctrl + W".exec = [
            "/usr/bin/open"
            "-a"
            "Helium"
          ];
          "Meta + Ctrl + Enter".exec = [
            "/usr/bin/open"
            "-a"
            "Rex Beta"
          ];
          "Meta + Ctrl + T".exec = [
            "/usr/bin/open"
            "-a"
            "Finder"
          ];
        }
        // listToAttrs (
          concatMap
            (
              {
                direction,
                vim,
                arrow,
                resize,
                axis,
              }:
              concatMap
                (key: [
                  (nameValuePair "Meta + Ctrl + ${key}" { move_focus = direction; })
                  (nameValuePair "Meta + Ctrl + Shift + ${key}" { move_node = direction; })
                  (nameValuePair "Meta + Ctrl + Alt + ${key}" { ${resize} = axis; })
                ])
                [
                  vim
                  arrow
                ]
            )
            [
              {
                direction = "left";
                vim = "H";
                arrow = "Left";
                resize = "resize_window_shrink";
                axis = "horizontal";
              }
              {
                direction = "down";
                vim = "J";
                arrow = "Down";
                resize = "resize_window_grow";
                axis = "vertical";
              }
              {
                direction = "up";
                vim = "K";
                arrow = "Up";
                resize = "resize_window_shrink";
                axis = "vertical";
              }
              {
                direction = "right";
                vim = "L";
                arrow = "Right";
                resize = "resize_window_grow";
                axis = "horizontal";
              }
            ]
        )
        // listToAttrs (
          concatMap (index: [
            (nameValuePair "Meta + Ctrl + ${toString index}" { switch_to_workspace = index - 1; })
            (nameValuePair "Meta + Ctrl + Shift + ${toString index}" { move_window_to_workspace = index - 1; })
          ]) (range 1 9)
        );
      };
    };
}
