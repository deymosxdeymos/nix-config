{
  flake.nixosModules.primary-user =
    { pkgs, ... }:
    {
      users.users.cfactoryai = {
        isNormalUser = true;
        description = "cfactoryai";
        shell = pkgs.nushell;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };

      programs.zsh.enable = true;

      environment.shells = [
        pkgs.nushell
        pkgs.zsh
        pkgs.bashInteractive
      ];
    };
}
