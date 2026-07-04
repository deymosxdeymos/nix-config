{
  inputs,
  lib,
  self,
  ...
}:
let
  inherit (lib.attrsets) attrValues removeAttrs;
  inherit (lib.trivial) flip;
in
{
  # osaka: headless DigitalOcean droplet (SGP1) — remote builder + agent host.
  # bcachefs root with tmpfs-backed impermanence, mirroring ncc's server hosts.
  flake.nixosConfigurations.osaka = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs self;
    };

    modules =
      (
        self.nixosModules
        |> flip removeAttrs [
          "browser"
          "desktop"
          "fonts"
          "hardware"
          "home"
          "hostname"
          "linux-boot"
          "linux-kernel"
        ]
        |> attrValues
      )
      ++ [
        inputs.disko.nixosModules.disko
        inputs.impermanence.nixosModules.impermanence
        inputs.agenix.nixosModules.age

        ./hardware.nix
        ./disko.nix
        ./configuration.nix
      ];
  };
}
