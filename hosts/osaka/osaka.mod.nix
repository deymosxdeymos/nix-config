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
  # Plain ext4 root for a reliable boot; agenix + tailscale + the shared skills.
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
        inputs.agenix.nixosModules.age

        ./hardware.nix
        ./disko.nix
        ./configuration.nix
      ];
  };
}
