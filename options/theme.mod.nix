let
  # A single source of truth for colours, fonts and spacing, consumed by both
  # NixOS (fonts) and home modules (ghostty). Colours come from a base16 scheme
  # via ThemeNix, so per-app config is generated (e.g. `theme.ghosttyConfig`)
  # rather than referenced by a fragile theme name.
  themeModule =
    {
      inputs,
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
          inputs.themes.raw.gruvbox-dark-hard
          // {
            padding = 8;

            font.size.normal = 12;
            font.size.big = 16;

            font.mono.name = "JetBrainsMono Nerd Font";
            font.mono.package = pkgs.nerd-fonts.jetbrains-mono;

            font.sans.name = "Lexend";
            font.sans.package = pkgs.lexend;
          }
        )
      );
    };
in
{
  flake.homeModules.theme = themeModule;
  flake.nixosModules.theme = themeModule;
}
