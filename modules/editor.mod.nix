{
  flake.homeModules.editor =
    { pkgs, ... }:
    {
      packages = [
        pkgs.basedpyright
        pkgs.deno
        pkgs.gopls
        pkgs.lua-language-server
        pkgs.marksman
        pkgs.neovim
        pkgs.nil
        pkgs.nixfmt
        pkgs.oxfmt
        pkgs.ruff
        pkgs.rust-analyzer
        pkgs.tailwindcss-language-server
        pkgs.texlab
        pkgs.ty
        pkgs.typescript-language-server
        pkgs.vscode-langservers-extracted
        pkgs.yaml-language-server
      ];

      files.".config/nvim".source = ./nvim;
    };
}
