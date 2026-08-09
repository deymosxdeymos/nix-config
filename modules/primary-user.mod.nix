{
  flake.nixosModules.primary-user =
    { pkgs, ... }:
    {
      users.users.cfactoryai = {
        isNormalUser = true;
        description = "cfactoryai";
        shell = pkgs.fish;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };

      programs.fish.enable = true;

      environment.shells = [
        pkgs.fish
        pkgs.bashInteractive
      ];
    };
}
