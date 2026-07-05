{
  inputs,
  lib,
  self,
  ...
}:
let
  inherit (lib.attrsets) attrValues;
in
{
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs self;
    };

    modules = attrValues self.nixosModules ++ [
      ./hardware-configuration.nix
      ./remote-builder.nix

      # Generic, model-agnostic ThinkPad tuning. If you know the exact model,
      # swap these for a specific profile (e.g. lenovo-thinkpad-x1-...).
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      inputs.nixos-hardware.nixosModules.common-cpu-intel

      inputs.watt.nixosModules.watt
    ];
  };
}
