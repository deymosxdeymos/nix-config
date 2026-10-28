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

      homebrew.casks = [
        "1password"
        "caffeine"
        "claude"
        "claude-code@latest"
        "codex"
        "dotnet-sdk"
        "helium-browser"
        "raycast"
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

        # Homebrew refuses formulae from untrusted third-party taps.
        trust.formulae = singleton "anomalyco/tap/opencode-v2";
      };
    };
}
