{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.nuke-default-packages;
  flake.darwinModules.nuke-default-packages = {
    environment.defaultPackages = [ ];

    system.tools.darwin-option.enable = false;
    system.tools.darwin-uninstaller.enable = false;
    system.tools.darwin-version.enable = false;
  };
}
