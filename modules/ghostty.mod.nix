{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.ghostty;
  flake.darwinModules.ghostty =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      homebrew.casks = singleton "ghostty";
    };

  flake.homeModules.default = self.homeModules.ghostty;
  flake.homeModules.ghostty =
    { lib, ... }:
    let
      inherit (lib.generators) mkKeyValueDefault toKeyValue;
    in
    {
      xdg.config.files."ghostty/config".generator = toKeyValue {
        mkKeyValue = mkKeyValueDefault { } " = ";
        listsAsDuplicateKeys = true;
      };
      xdg.config.files."ghostty/config".value = {
        # 100 MiB
        scrollback-limit = 100 * 1024 * 1024;

        mouse-hide-while-typing = true;

        # Updated through Homebrew.
        auto-update = "off";
      };
    };
}
