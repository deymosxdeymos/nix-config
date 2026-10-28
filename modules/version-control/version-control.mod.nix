{ self, ... }:
{
  flake.homeModules.default.imports = [
    self.homeModules.difftastic
    self.homeModules.gh
    self.homeModules.git
    self.homeModules.jujutsu
    self.homeModules.mergiraf
    self.homeModules.watchman
  ];

  flake.homeModules.gh =
    { lib, pkgs, ... }:
    let
      inherit (lib.generators) toGitINI;
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
      inherit (lib.modules) mkDefault;
    in
    {
      packages = singleton pkgs.gh;


      xdg.config.files."git/config".generator = mkDefault toGitINI;
      xdg.config.files."git/config".value.credential = {
        "https://github.com".helper = [
          ""
          "!${getExe pkgs.gh} auth git-credential"
        ];
        "https://gist.github.com".helper = [
          ""
          "!${getExe pkgs.gh} auth git-credential"
        ];
      };
    };

  flake.homeModules.git =
    { lib, pkgs, ... }:
    let
      inherit (lib.generators) toGitINI;
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
    in
    {
      packages = singleton pkgs.git;

      xdg.config.files."fish/conf.d/git.fish".text = /* fish */ ''
        alias g 'git'
        alias gst 'git status'
        alias gsb 'git status --short --branch'
        alias gc 'git commit --verbose'
        alias s 'git status'
        alias gaa 'git add -A'
        alias gap 'git add --patch'
        alias co 'git switch'
        alias gco 'git switch'
        alias gcb 'git switch --create'
        alias gcm 'git switch (__git.default_branch)'
        alias gd 'git diff'
        alias gdc 'git diff --cached'
        alias up 'git push'
        alias upf 'git push --force-with-lease'
        alias gpu 'git push --set-upstream origin (__git.current_branch)'
        alias pu 'git pull'
        alias pur 'git pull --rebase'
        alias fe 'git fetch'
        alias gfa 'git fetch --all --prune'
        alias re 'git rebase'
        alias grbi 'git rebase --interactive'
        alias glog 'git log --oneline --decorate --graph'
        alias gloga 'git log --oneline --decorate --graph --all'
        alias lr 'git l -30'
        alias hs 'git rev-parse --short HEAD'
        alias hm 'git log --format=%B -n 1 HEAD'
      '';

      xdg.config.files."git/ignore".text = /* gitignore */ ''
        **/.claude/settings.local.json
        .direnv/
      '';

      xdg.config.files."ssh/allowed_signers".text = /* sshallowedsigners */ ''
        ${self.people.self.email} ${self.people.self.ssh.key}
      '';

      xdg.config.files."git/config".generator = toGitINI;
      xdg.config.files."git/config".value = {
        user = {
          inherit (self.people.self) name email;
          signingKey = "~/.ssh/id_ed25519.pub";
        };

        alias.fomo = "!${getExe pkgs.fish} -c 'git fetch origin (__git.default_branch); and git rebase origin/(__git.default_branch) --autostash'";
        alias.lg = "log --oneline --decorate --graph";

        branch.sort = "-committerdate";

        column.ui = "auto";

        commit.gpgSign = true;
        tag.gpgSign = true;

        gpg.format = "ssh";
        "gpg \"ssh\"".allowedSignersFile = "~/.config/ssh/allowed_signers";

        core.editor = "hx";
        core.fsmonitor = true;

        fetch.prune = true;
        fetch.writeCommitGraph = true;

        init.defaultBranch = "main";

        pull.rebase = true;

        rebase.autoStash = true;
        rebase.updateRefs = true;

        rerere.enabled = true;

        fetch.fsckObjects = true;
        receive.fsckObjects = true;
        transfer.fsckobjects = true;
      };
    };

  flake.homeModules.jujutsu =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
      inherit (lib.strings) toLower;
    in
    {
      packages = singleton pkgs.jujutsu;

      xdg.config.files."fish/conf.d/jujutsu.fish".text = /* fish */ ''
        alias j 'jj'
        alias jjj 'jj'
      '';

      xdg.config.files."jj/config.toml".generator = pkgs.writers.writeTOML "jj-config.toml";
      xdg.config.files."jj/config.toml".value = {
        user = {
          inherit (self.people.self) name email;
        };

        aliases.".." = [
          "edit"
          "@-"
        ];
        aliases.",," = [
          "edit"
          "@+"
        ];

        aliases.fetch = [
          "git"
          "fetch"
        ];
        aliases.f = [
          "git"
          "fetch"
        ];

        aliases.push = [
          "git"
          "push"
        ];
        aliases.p = [
          "git"
          "push"
        ];

        aliases.clone = [
          "git"
          "clone"
        ];
        aliases.cl = [
          "git"
          "clone"
        ];

        aliases.init = [
          "git"
          "init"
        ];
        aliases.i = [
          "git"
          "init"
        ];

        aliases.a = singleton "abandon";

        aliases.c = singleton "commit";
        aliases.ci = [
          "commit"
          "--interactive"
        ];

        aliases.d = singleton "diff";

        aliases.e = singleton "edit";

        aliases.l = singleton "log";
        aliases.la = [
          "log"
          "--revisions"
          "::"
        ];
        aliases.ls = [
          "log"
          "--summary"
        ];
        aliases.lsa = [
          "log"
          "--summary"
          "--revisions"
          "::"
        ];
        aliases.lp = [
          "log"
          "--patch"
        ];
        aliases.lpa = [
          "log"
          "--patch"
          "--revisions"
          "::"
        ];

        aliases.r = singleton "rebase";

        aliases.res = singleton "resolve";

        aliases.s = singleton "squash";
        aliases.si = [
          "squash"
          "--interactive"
        ];

        aliases.sh = singleton "show";

        aliases.tug = [
          "bookmark"
          "move"
          "--from"
          "closest(@-)"
          "--to"
          "closest_pushable(@)"
        ];
        aliases.t = singleton "tug";

        aliases.u = singleton "undo";

        aliases.open = [
          "util"
          "exec"
          "--"
          (
            getExe
            <| pkgs.writers.writeNuBin "jj-open" /* nu */ ''
              def resolve-revision [revision: string] {
                do { jj --ignore-working-copy log --no-graph --template commit_id --revisions $revision }
                | complete
                | if $in.exit_code == 0 { $in.stdout }
              }

              def resolve-revision-in [--remote: any, symbol: string] {
                [(if $remote != null { $"($symbol)@($remote)" }) $symbol]
                | compact
                | where {|candidate| resolve-revision $candidate | is-not-empty }
                | get --optional 0
              }

              def main [
                --at: path = ~/Developer
                url: string
              ] {
                let span = (metadata $url).span
                let url = $url | url parse

                let target = match ($url.path | split row "/" | where { is-not-empty }) {
                  [$owner, $repository] => {
                    owner: $owner,
                    repository: $repository,
                    revision: "@",
                    file: "."
                  }

                  [$owner, $repository, _, $revision, ..$file] => {
                    owner: $owner
                    repository: $repository
                    revision: $'"($revision)"'
                    file: ($file | path join | default "." --empty)
                  }

                  _ => {
                    error make {
                      msg: "not a repository url"
                      label: {
                        text: "expected <owner>/<repository>"
                        span: $span
                      }
                    }
                  }
                }
                | insert line ($url.fragment | parse --regex 'L(?<line>\d+)' | get --optional line.0)

                let repository_url = {
                  scheme: $url.scheme
                  host: $url.host
                  path: $"/($target.owner)/($target.repository)"
                }
                | url join

                do --env {
                  let destination = $at | path join $target.repository

                  if not ($destination | path exists) {
                    jj git clone $repository_url $destination
                  }

                  cd $destination
                }

                let remote = do {
                  let existing = jj git remote list
                  | lines
                  | parse "{name} {url}"
                  | where {|remote| $remote.url | str replace --regex '\.git$' "" | str ends-with $"($target.owner)/($target.repository)" }
                  | get --optional name.0

                  if $existing != null {
                    return $existing
                  }

                  jj git remote add $target.owner $repository_url
                  $target.owner
                }

                let symbol = do {
                  let symbol = resolve-revision-in --remote $remote $target.revision

                  if $symbol != null {
                    return $symbol
                  }

                  jj git fetch --remote $remote
                  let symbol = resolve-revision-in --remote $remote $target.revision

                  if $symbol == null {
                    error make {
                      msg: $"unknown revision: ($target.revision)"
                      label: {
                        text: "from here"
                        span: $span
                      }
                    }
                  }

                  $symbol
                }

                if (resolve-revision $"($symbol) & @ | ($symbol) & @-" | is-empty) {
                  jj new $symbol
                }

                exec $env.EDITOR (match $target.line {
                  null => $target.file
                  $line => $"($target.file):($line)"
                })
              }
            ''
          )
        ];

        aliases.fork = [
          "util"
          "exec"
          "--"
          (
            getExe
            <| pkgs.writers.writeNuBin "jj-fork" /* nu */ ''
              def remote-names [] {
                jj git remote list | lines | parse "{name} {url}" | get name
              }

              if "upstream" not-in (remote-names) {
                jj git remote rename origin upstream
              }

              if "origin" not-in (remote-names) {
                gh repo fork --remote --remote-name origin
              }

              jj git fetch

              jj bookmark track (jj config get 'revset-aliases."trunk()"' | split row "@" | first)
            ''
          )
        ];


        revset-aliases."closest(to)" = "heads(::to & bookmarks())";
        revset-aliases."closest_pushable(to)" =
          ''heads(::to & ~description(exact:"") & (~empty() | merges()))'';

        revsets.bookmark-advance-from = /* python */ ''
          coalesce(
            heads(::to & bookmarks() & ~immutable()),
            heads(::to & bookmarks()),
          )
        '';

        revsets.bookmark-advance-to = /* python */ ''
          heads(::@ & mutable() & ~description(exact:"") & (~empty() | merges()))
        '';

        revsets.log = /* python */ ''
          present(@) | present(trunk()) | ancestors(remote_bookmarks().. | @.., 8)
        '';

        ui.default-command = "ls";

        ui.diff-editor = ":builtin";

        ui.conflict-marker-style = "snapshot";
        ui.graph.style = "curved";

        templates.draft_commit_description = /* python */ ''
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

        templates.git_push_bookmark = /* python */ ''
          "${toLower self.people.self.name}/change-" ++ change_id.short()
        '';

        remotes."*" = {
          auto-track-bookmarks = "${toLower self.people.self.name}/*";
          auto-track-created-bookmarks = "*";
        };

        git.fetch = [
          "origin"
          "upstream"
        ];
        git.push = "origin";

        signing.behavior = "drop";
        git.sign-on-push = true;

        signing.backend = "ssh";
        signing.key = "~/.ssh/id_ed25519.pub";
      };
    };

  flake.homeModules.difftastic =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
      inherit (lib.modules) mkDefault;
    in
    {
      packages = singleton pkgs.difftastic;

      xdg.config.files."jj/config.toml".generator = mkDefault <| pkgs.writers.writeTOML "jj-config.toml";
      xdg.config.files."jj/config.toml".value.ui.diff-formatter = [
        (getExe pkgs.difftastic)
        "--color"
        "always"
        "$left"
        "$right"
      ];
    };

  flake.homeModules.watchman =
    { lib, pkgs, ... }:
    let
      inherit (lib.generators) toJSON;
      inherit (lib.lists) singleton;
      inherit (lib.modules) mkDefault;
    in
    {
      packages = singleton pkgs.watchman;

      xdg.config.files."watchman/watchman.json".generator = toJSON { };
      xdg.config.files."watchman/watchman.json".value = {
        ignore_dirs = [
          ".direnv"
          "node_modules"
          "target"
        ];
      };

      xdg.config.files."jj/config.toml".generator = mkDefault <| pkgs.writers.writeTOML "jj-config.toml";
      xdg.config.files."jj/config.toml".value = {
        fsmonitor.backend = "watchman";
        fsmonitor.watchman.register-snapshot-trigger = true;
      };
    };

  flake.homeModules.mergiraf =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
      inherit (lib.modules) mkDefault;
    in
    {
      packages = singleton pkgs.mergiraf;

      xdg.config.files."jj/config.toml".generator = mkDefault <| pkgs.writers.writeTOML "jj-config.toml";
      xdg.config.files."jj/config.toml".value = {
        aliases.resolve-ast = [
          "resolve"
          "--tool"
          "mergiraf"
        ];
        aliases.resa = singleton "resolve-ast";

        merge-tools.mergiraf.program = getExe pkgs.mergiraf;
      };
    };
}
