{
  flake.homeModules.difftastic =
    { pkgs, ... }:
    {
      packages = [ pkgs.difftastic ];
    };
}
