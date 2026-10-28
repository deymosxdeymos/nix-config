{ self, inputs, ... }:
{
  flake.darwinModules.default = self.darwinModules.nix;
  flake.darwinModules.nix =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.attrsets) filterAttrs mapAttrs;
      inherit (lib.lists) elem singleton;
      inherit (lib.options) mkOption;
      inherit (lib.strings) getName;
      inherit (lib.trivial) const;
      inherit (lib.types) isType listOf str;
    in
    {
      # Determinate Nix manages the daemon and /etc/nix/nix.conf itself,
      # so nix-darwin's `nix.*` is disabled and settings go to nix.custom.conf.
      imports = singleton inputs.determinate.darwinModules.default;

      options.nixpkgs.allowedUnfreePackages = mkOption {
        type = listOf str;
        default = [ ];
        description = "List of unfree package names to allow.";
      };

      config = {
        nixpkgs.config.allowUnfreePredicate =
          package: elem (getName package) config.nixpkgs.allowedUnfreePackages;

        environment.systemPackages = [
          pkgs.dix
          pkgs.nh
          pkgs.nix-output-monitor
        ];

        determinateNix.customSettings = (import <| self + /flake.nix).nixConfig;

        determinateNix.determinateNixd.garbageCollector.strategy = "automatic";

        determinateNix.registry =
          filterAttrs (const <| isType "flake") inputs // { default = inputs.nixpkgs; }
          |> mapAttrs (_: flake: { inherit flake; });
      };
    };

  flake.homeModules.default = self.homeModules.nix;
  flake.homeModules.nix =
    { config, ... }:
    {
      environment.sessionVariables.NH_FLAKE = "${config.directory}/Developer/nix-config";
    };
}
