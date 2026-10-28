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
    {
      config,
      lib,
      osConfig,
      ...
    }:
    let
      inherit (lib.attrsets) attrNames;
      inherit (lib.strings) concatStringsSep;
    in
    {
      environment.sessionVariables.NH_FLAKE = "${config.directory}/Developer/nix-config";

      xdg.config.files."fish/conf.d/nix-run.fish".text = /* fish */ ''
        function __nix_reference
            if string match --quiet --regex '[#:]' -- $argv[1]
                echo $argv[1]
            else if contains -- $argv[1] ${
              self.packages.${osConfig.nixpkgs.hostPlatform.system} |> attrNames |> concatStringsSep " "
            }
                echo "path:${self}#$argv[1]"
            else
                echo "path:${inputs.nixpkgs}#$argv[1]"
            end
        end

        function , --wraps 'nix run' --description 'nix run a package'
            nix run (__nix_reference $argv[1]) -- $argv[2..]
        end

        function ,, --description 'nix shell with packages'
            nix shell (for package in $argv; __nix_reference $package; end)
        end
      '';
    };
}
