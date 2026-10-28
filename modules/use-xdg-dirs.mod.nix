{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.use-xdg-dirs;
  flake.darwinModules.use-xdg-dirs =
    { config, ... }:
    {
      # The watchman daemon is spawned by launchd with a minimal environment,
      # so WATCHMAN_CONFIG_FILE can't reach it. the compiled-in /etc path can.
      environment.etc."watchman.json".source = "${
        config.home.users.${config.system.primaryUser}.xdg.config.directory
      }/watchman/watchman.json";
    };

  flake.homeModules.default = self.homeModules.use-xdg-dirs;
  flake.homeModules.use-xdg-dirs =
    { config, ... }:
    {
      xdg.config.files."codex".type = "directory";
      environment.sessionVariables.CODEX_HOME = "${config.xdg.config.directory}/codex";

      xdg.config.files."claude-code".type = "directory";
      environment.sessionVariables.CLAUDE_CONFIG_DIR = "${config.xdg.config.directory}/claude-code";

      files.".ssh/config".text =
        # sshclientconfig
        ''
          Include ${config.xdg.config.directory}/ssh/config
        '';

      xdg.config.files."zsh".type = "directory";
      environment.sessionVariables.ZDOTDIR = "${config.xdg.config.directory}/zsh";

      xdg.data.files."bun".type = "directory";
      environment.sessionVariables.BUN_INSTALL = "${config.xdg.data.directory}/bun";

      xdg.data.files."cargo".type = "directory";
      environment.sessionVariables.CARGO_HOME = "${config.xdg.data.directory}/cargo";

      xdg.data.files."go".type = "directory";
      environment.sessionVariables.GOPATH = "${config.xdg.data.directory}/go";

      xdg.config.files."ripgrep".type = "directory";
      environment.sessionVariables.RIPGREP_CONFIG_PATH = "${config.xdg.config.directory}/ripgrep/config";

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

      environment.sessionVariables.WATCHMAN_CONFIG_FILE = "${config.xdg.config.directory}/watchman/watchman.json";
    };
}
