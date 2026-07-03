{
  flake.nixosModules.nix =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.nh
        pkgs.nix-output-monitor
        pkgs.nvd
      ];

      # Automatic garbage collection so the Nix store doesn't grow unbounded.
      nix.gc = {
        automatic = true;
        dates = "weekly";
        persistent = true;
        options = "--delete-older-than 14d";
      };

      # Deduplicate identical files in the store.
      nix.optimise.automatic = true;

      nix.settings.experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operators"
      ];

      # nh wraps nixos-rebuild with nicer output; point it at this flake.
      programs.nh = {
        enable = true;
        flake = "/home/cfactoryai/Documents/nix-config";
      };
    };
}
