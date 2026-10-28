{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.editor;
  flake.darwinModules.editor = {
    environment.variables.EDITOR = "hx";
  };

  flake.homeModules.default = self.homeModules.editor;
  flake.homeModules.editor =
    { pkgs, ... }:
    {
      environment.sessionVariables.EDITOR = "hx";

      packages = [
        pkgs.helix
        pkgs.neovim

        pkgs.lua-language-server
        pkgs.nil
        pkgs.nixfmt
        pkgs.ruff
        pkgs.rust-analyzer
        pkgs.tailwindcss-language-server
        pkgs.ty
        pkgs.vscode-langservers-extracted
      ];

      xdg.config.files."nvim/init.lua".source = ./init.lua;
    };
}
