{
  flake.homeModules.git =
    { lib, pkgs, ... }:
    let
      inherit (lib.generators) toGitINI;
    in
    {
      packages = [
        pkgs.gitMinimal
        pkgs.lazygit
      ];

      xdg.config.files."git/ignore".text = ''
        .direnv/
      '';

      xdg.config.files."git/config".generator = toGitINI;
      xdg.config.files."git/config".value = {
        user.name = "deymosxdeymos";
        user.email = "galinnichola15@gmail.com";

        init.defaultBranch = "main";
        pull.rebase = true;
        rebase.autoStash = true;

        fetch.fsckObjects = true;
        receive.fsckObjects = true;
        transfer.fsckobjects = true;

        url."ssh://git@github.com/".insteadOf = "https://github.com/";
      };
    };
}
