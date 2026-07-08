{
  flake.homeModules.jujutsu =
    {
      config,
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
        aliases.tug = [
          "bookmark"
          "move"
          "--from"
          "closest_bookmark(@-)"
          "--to"
          "@-"
        ];
        aliases.u = [ "undo" ];

        aliases.fork = [
          "util"
          "exec"
          "--"
          (pkgs.writeScript "jj-fork" /* nu */ ''
            #!${getExe pkgs.nushell}
            #

            gh repo fork --remote
            gh repo set-default upstream

            let trunk = jj --ignore-working-copy config get 'revset-aliases."trunk()"'
            jj --ignore-working-copy config set --repo 'revset-aliases."trunk()"' ($trunk | str replace "origin" "upstream")

            jj git fetch

            jj bookmark track ($trunk | split row "@" | first) --remote upstream
            jj bookmark track ($trunk | split row "@" | first) --remote origin
          '')
        ];

        revsets.bookmark-advance-to = ''
          heads(::@ & ~description(exact:"") & (~empty() | merges()))
        '';

        revset-aliases."closest_bookmark(to)" = "heads(::to & bookmarks())";

        revsets.log = ''
          present(@) | present(trunk()) | ancestors(remote_bookmarks().. | @.., 8)
        '';

        ui.default-command = "log";

        ui.diff-editor = ":builtin";
        ui.pager = [
          (getExe pkgs.bash)
          "-c"
          "exec \${PAGER:-less}"
        ];
        ui.conflict-marker-style = "snapshot";
        ui.graph.style = if config.theme.cornerRadius > 0 then "curved" else "square";

        templates.draft_commit_description = ''
          concat(
            coalesce(description, "\n"),
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.stat(72)),
            ),
            "\nJJ: ignore-rest\n",
            diff.git(),
          )
        '';

        templates.git_push_bookmark = ''
          "deymosxdeymos/change-" ++ change_id.short()
        '';

        remotes."*" = {
          auto-track-bookmarks = "deymosxdeymos/*";
          push-new-bookmarks = true;
        };

        git.fetch = [
          "origin"
          "upstream"
        ];
        git.push = "origin";
        git.sign-on-push = true;

        signing.backend = "ssh";
        signing.behavior = "drop";
        signing.key = "${config.directory}/.ssh/id_ed25519";
      };
    };
}
