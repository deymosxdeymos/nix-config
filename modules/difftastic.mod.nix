{
  flake.homeModules.difftastic =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.meta) getExe;
      inherit (lib.generators) toGitINI;
      inherit (lib.lists) singleton;

      difft = pkgs.writeShellScriptBin "difft" /* bash */ ''
        exec ${getExe pkgs.difftastic} --background ${if config.theme.isDark then "dark" else "light"} "$@"
      '';
    in
    {
      packages = singleton difft;

      # GIT INTEGRATION
      xdg.config.files."git/config".generator = toGitINI;
      xdg.config.files."git/config".value = {
        diff.external = getExe difft;
        diff.tool = "difftastic";
        difftool.difftastic.cmd = ''${getExe difft} "$LOCAL" "$REMOTE"'';
      };
    };
}
