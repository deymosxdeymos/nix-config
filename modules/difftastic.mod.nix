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
      inherit (lib.modules) mkDefault;

      difft = pkgs.writeShellScriptBin "difft" /* bash */ ''
        exec ${getExe pkgs.difftastic} --background ${if config.theme.isDark then "dark" else "light"} "$@"
      '';
    in
    {
      packages = singleton difft;

      # GIT INTEGRATION
      xdg.config.files."git/config".generator = mkDefault toGitINI;
      xdg.config.files."git/config".value = {
        diff.external = getExe difft;
        diff.tool = "difftastic";
        difftool.difftastic.cmd = ''${getExe difft} "$LOCAL" "$REMOTE"'';
      };

      # JUJUTSU INTEGRATION
      xdg.config.files."jj/config.toml".generator = mkDefault <| pkgs.writers.writeTOML "jj-config.toml";
      xdg.config.files."jj/config.toml".value.ui.diff-formatter = [
        (getExe difft)
        "--color"
        "always"
        "$left"
        "$right"
      ];
    };
}
