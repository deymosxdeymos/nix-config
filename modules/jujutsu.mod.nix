{
  flake.homeModules.jujutsu =
    {
      self,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.meta) getExe;
    in
    {
      packages = [
        pkgs.jjui
        pkgs.jujutsu
        pkgs.mergiraf
      ];

      xdg.config.files."jj/config.toml".generator = pkgs.writers.writeTOML "jj-config.toml";
      xdg.config.files."jj/config.toml".value = {
        user.name = "deymosxdeymos";
        user.email = "galinnichola15@gmail.com";

        # NAVIGATION
        aliases.".." = [
          "edit"
          "@-"
        ];
        aliases.",," = [
          "edit"
          "@+"
        ];

        # GIT SHORTCUTS
        aliases.f = [
          "git"
          "fetch"
        ];
        aliases.p = [
          "git"
          "push"
        ];
        aliases.cl = [
          "git"
          "clone"
        ];
        aliases.i = [
          "git"
          "init"
        ];

        # CORE
        aliases.a = [ "abandon" ];
        aliases.c = [ "commit" ];
        aliases.ci = [
          "commit"
          "--interactive"
        ];
        aliases.d = [ "diff" ];
        aliases.e = [ "edit" ];
        aliases.l = [ "log" ];
        aliases.la = [
          "log"
          "--revisions"
          "::"
        ];
        aliases.r = [ "rebase" ];
        aliases.res = [ "resolve" ];
        aliases.resa = [ "resolve-ast" ];
        aliases.resolve-ast = [
          "resolve"
          "--tool"
          "${getExe pkgs.mergiraf}"
        ];
        aliases.s = [ "squash" ];
        aliases.si = [
          "squash"
          "--interactive"
        ];
        aliases.sh = [ "show" ];
        aliases.u = [ "undo" ];

        revsets.log = ''
          present(@) | present(trunk()) | ancestors(remote_bookmarks().. | @.., 8)
        '';

        ui.default-command = "log";
        ui.diff-formatter = [
          "difft"
          "--color=always"
          "$left"
          "$right"
        ];
        ui.pager = [
          (getExe pkgs.bash)
          "-c"
          "exec \${PAGER:-less}"
        ];
        ui.conflict-marker-style = "snapshot";
        ui.graph.style = "curved";

        templates.git_push_bookmark = ''
          "deymosxdeymos/change-" ++ change_id.short()
        '';

        remotes."*" = {
          auto-track-bookmarks = "deymosxdeymos/*";
          push-new-bookmarks = true;
        };

        git.push = "origin";
        git.sign-on-push = true;

        # SSH COMMIT SIGNING (ncc-style: sign at push, not every local commit)
        signing.backend = "ssh";
        signing.behavior = "drop";
        signing.key = self.keys.deymosxdeymos;
      };
    };
}
