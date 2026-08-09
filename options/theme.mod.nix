let
  # A single source of truth for colours, fonts and spacing, consumed by both
  # NixOS and home modules. Colours use Catppuccin Macchiato as the static
  # dark palette; applications with runtime theme switching use Latte by day.
  themeModule =
    {
      inputs,
      self,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.modules) mkDefault;
      inherit (lib.options) mkOption;
      inherit (lib.types) attrs;
    in
    {
      options.theme = mkOption {
        type = attrs;
        default = { };
        description = "Base16 theme plus derived font and spacing settings.";
      };

      config.theme = mkDefault (
        inputs.themes.custom (
          inputs.themes.raw.catppuccin-macchiato
          // {
            cornerRadius = 4;
            borderWidth = 2;

            margin = 0;
            padding = 8;

            font.size.normal = 12;
            font.size.big = 16;

            font.sans.name = "Lexend";
            font.sans.package = pkgs.lexend;

            font.mono.name = "TX-02 SemiCondensed";
            font.mono.package = self.packages.${pkgs.stdenv.hostPlatform.system}.tx-02;

            icons.name = "breeze-dark";
            icons.package = pkgs.kdePackages.breeze-icons;
          }
        )
      );
    };
in
{
  flake.homeModules.theme = themeModule;
  flake.nixosModules.theme = themeModule;
}
