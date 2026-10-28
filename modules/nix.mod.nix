{ self, inputs, ... }:
{
  flake.darwinModules.default = self.darwinModules.nix;
  flake.darwinModules.nix =
    { lib, pkgs, ... }:
    let
      inherit (lib.attrsets) filterAttrs mapAttrs;
      inherit (lib.lists) singleton;
      inherit (lib.trivial) const;
      inherit (lib.types) isType;
    in
    {
      imports = singleton inputs.determinate.darwinModules.default;

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

  flake.homeModules.default = self.homeModules.nix;
  flake.homeModules.nix =
    { config, ... }:
    {
      environment.sessionVariables.NH_FLAKE = "${config.directory}/Developer/nix-config";
    };
}
