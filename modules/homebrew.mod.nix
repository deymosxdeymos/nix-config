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

      homebrew.taps = attrNames config.nix-homebrew.taps;

      homebrew.onActivation.autoUpdate = false;
      homebrew.onActivation.upgrade = false;
      homebrew.onActivation.cleanup = "none";

      homebrew.casks = [
        "1password"
        "caffeine"
        "claude"
        "claude-code@latest"
        "codex"
        "dotnet-sdk"
        "raycast"
        "tailscale-app"
        "thebrowsercompany-dia"
      ];

      homebrew.brews = singleton "anomalyco/tap/opencode-v2";

      nix-homebrew = {
        enable = true;

        user = config.system.primaryUser;

        autoMigrate = true;

        taps."homebrew/homebrew-core" = inputs.homebrew-core;
        taps."homebrew/homebrew-cask" = inputs.homebrew-cask;
        taps."anomalyco/homebrew-tap" = inputs.homebrew-anomalyco;

        mutableTaps = false;

        trust.formulae = singleton "anomalyco/tap/opencode-v2";
      };
    };
}
