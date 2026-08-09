{
  flake.nixosModules.fish =
    { pkgs, ... }:
    {
      programs.fish.enable = true;

      environment.shells = [ pkgs.fish ];
    };

  flake.homeModules.fish =
    { pkgs, ... }:
    {
      packages = [
        pkgs.atuin
        pkgs.fish
        pkgs.mise
        pkgs.pstree
        pkgs.starship
      ];

      files.".config/fish".source = ./fish;
    };
}
