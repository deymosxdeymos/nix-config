{
  flake.nixosModules.packages =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = [
        pkgs.curl
        pkgs.git
        pkgs.ghostty.terminfo
        pkgs.nano
        pkgs.vim
        pkgs.wget
      ];
    };

  flake.homeModules.packages-shell-utils =
    { pkgs, ... }:
    {
      packages = [
        pkgs.delta
        pkgs.duf
        pkgs.eza
        pkgs.fd
        pkgs.fzf
        pkgs.hyperfine
        pkgs.tokei
        pkgs.tree
      ];

      rum.programs.direnv = {
        enable = true;
        integrations.nix-direnv.enable = true;
        integrations.nushell.enable = true;
      };

      rum.programs.fzf.enable = true;

      rum.programs.zoxide = {
        enable = true;
        flags = [
          "--cmd"
          "cd"
        ];
        integrations.nushell.enable = true;
      };
    };
}
