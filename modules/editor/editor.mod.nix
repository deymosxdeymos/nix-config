{ self, ... }:
{
  flake.homeModules.default = self.homeModules.editor;
  flake.homeModules.editor =
    { pkgs, ... }:
    {
      environment.sessionVariables.EDITOR = "hx";

      packages = [
        pkgs.helix
        pkgs.neovim

        # LANGUAGE SERVERS
        # init.lua only enables the ones it finds on PATH.
        pkgs.lua-language-server
        pkgs.nil
        pkgs.nixfmt
        pkgs.ruff
        pkgs.rust-analyzer
        pkgs.tailwindcss-language-server
        pkgs.ty
        pkgs.vscode-langservers-extracted
      ];

      # nvim-pack-lock.json is written by vim.pack, so it stays unmanaged.
      xdg.config.files."nvim/init.lua".source = ./init.lua;
    };
}
