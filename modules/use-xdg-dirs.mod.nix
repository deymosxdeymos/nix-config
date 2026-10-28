{ self, ... }:
{
  flake.homeModules.default = self.homeModules.use-xdg-dirs;
  flake.homeModules.use-xdg-dirs =
    { config, ... }:
    {
      xdg.config.files."codex".type = "directory";
      environment.sessionVariables.CODEX_HOME = "${config.xdg.config.directory}/codex";

      xdg.config.files."claude-code".type = "directory";
      environment.sessionVariables.CLAUDE_CONFIG_DIR = "${config.xdg.config.directory}/claude-code";

      xdg.config.files."zsh".type = "directory";
      environment.sessionVariables.ZDOTDIR = "${config.xdg.config.directory}/zsh";

      xdg.data.files."cargo".type = "directory";
      environment.sessionVariables.CARGO_HOME = "${config.xdg.data.directory}/cargo";

      xdg.data.files."go".type = "directory";
      environment.sessionVariables.GOPATH = "${config.xdg.data.directory}/go";

      xdg.data.files."bun".type = "directory";
      environment.sessionVariables.BUN_INSTALL = "${config.xdg.data.directory}/bun";

      xdg.state.files."sqlite".type = "directory";
      environment.sessionVariables.SQLITE_HISTORY = "${config.xdg.state.directory}/sqlite/history";

      xdg.state.files."zsh".type = "directory";
      environment.sessionVariables.HISTFILE = "${config.xdg.state.directory}/zsh/history";

      xdg.state.files."less".type = "directory";
      environment.sessionVariables.LESSHISTFILE = "${config.xdg.state.directory}/less/history";

      xdg.state.files."node".type = "directory";
      environment.sessionVariables.NODE_REPL_HISTORY = "${config.xdg.state.directory}/node/history";

      xdg.state.files."python".type = "directory";
      environment.sessionVariables.PYTHON_HISTORY = "${config.xdg.state.directory}/python/history";
    };
}
