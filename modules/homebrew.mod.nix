{ inputs, self, ... }:
{
  flake.darwinModules.default = self.darwinModules.homebrew;
  flake.darwinModules.homebrew =
    { config, lib, ... }:
    let
      inherit (lib.attrsets) attrNames;
      inherit (lib.lists) singleton;
    in
    {
      imports = singleton inputs.homebrew.darwinModules.nix-homebrew;

      homebrew.enable = true;

      # Taps are pinned through flake inputs, so brew must not try to manage them.
      homebrew.taps = attrNames config.nix-homebrew.taps;

      homebrew.onActivation.autoUpdate = false;
      homebrew.onActivation.upgrade = false;
      # TODO: Switch to "zap" once everything not listed here has been uninstalled.
      homebrew.onActivation.cleanup = "none";

      # 1Password, Claude, Helium and Raycast stay unmanaged: adopting them
      # (`brew install --cask --adopt`) is blocked by macOS App Management even
      # with the permission granted to the terminal. They update themselves.
      homebrew.casks = [
        "caffeine"
        "claude-code@latest"
        "codex"
        "dotnet-sdk"
        "tailscale-app"
      ];

      homebrew.brews = singleton "anomalyco/tap/opencode-v2";

      nix-homebrew = {
        enable = true;

        user = config.system.primaryUser;

        # Take over the existing /opt/homebrew installation.
        autoMigrate = true;

        taps."homebrew/homebrew-core" = inputs.homebrew-core;
        taps."homebrew/homebrew-cask" = inputs.homebrew-cask;
        taps."anomalyco/homebrew-tap" = inputs.homebrew-anomalyco;

        mutableTaps = false;
      };
    };
}
