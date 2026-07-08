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

      # Open more parallel connections to substituters so prebuilt binaries
      # download faster on this bandwidth-over-cores machine. Once a remote
      # builder is configured, let it fetch from caches instead of streaming
      # everything back through here.
      nix.settings.http-connections = 50;
      nix.settings.builders-use-substitutes = true;

      # Prebuilt pi (lukasl-dev/pi.nix) binaries so pi isn't built from source.
      nix.settings.extra-substituters = [
        "https://pi.cachix.org"
        "https://nix-community.cachix.org"
      ];
      nix.settings.extra-trusted-public-keys = [
        "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      # nh wraps nixos-rebuild with nicer output; point it at this flake.
      programs.nh = {
        enable = true;
        flake = "/home/cfactoryai/Documents/nix-config";
      };
    };
}
