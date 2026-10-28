{ self }:
{
  systems.darwinSystem =
    hostName: module:
    { inputs, ... }:
    {
      flake.darwinConfigurations.${hostName} = inputs.nix-darwin.lib.darwinSystem {
        lib = self;

        modules = [
          inputs.self.darwinModules.default

          module

          {
            networking.hostName = hostName;
          }
        ];
      };
    };
}
