{
  flake.homeModules.git =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.generators) toGitINI;
      inherit (lib.meta) getExe getExe';
      git = getExe pkgs.gitMinimal;
      githelpers = pkgs.writeText "githelpers" /* bash */ ''
        HASH="%C(always,yellow)%h%C(always,reset)"
        RELATIVE_TIME="%C(always,green)%ar%C(always,reset)"
        AUTHOR="%C(always,bold blue)%an%C(always,reset)"
        REFS="%C(always,red)%d%C(always,reset)"
        SUBJECT="%s"

        FORMAT="$HASH $RELATIVE_TIME{$AUTHOR{$REFS $SUBJECT"

        pretty_git_log() {
          ${git} log --graph --pretty="tformat:$FORMAT" $* |
          ${getExe' pkgs.util-linux "column"} --table --separator '{' |
          ${getExe pkgs.less} --no-init --RAW-CONTROL-CHARS --chop-long-lines --quit-if-one-screen
        }

        remove_untracked_files() {
          ${git} ls-files --other --exclude-standard \
            | ${getExe' pkgs.findutils "xargs"} ${getExe' pkgs.coreutils "rm"} --recursive --force
        }
      '';
    in
    {
      packages = [
        pkgs.gitMinimal
        pkgs.git-lfs
        pkgs.lazygit
      ];

      xdg.config.files."git/ignore".text = ''
        .direnv/
      '';

      xdg.config.files."git/config".generator = toGitINI;
      xdg.config.files."git/config".value = {
        user.name = "deymosxdeymos";
        user.email = "galinnichola15@gmail.com";

        # SSH signing, matching the jujutsu configuration.
        user.signingKey = "${config.directory}/.ssh/id_ed25519";
        gpg.format = "ssh";
        commit.gpgSign = true;
        tag.gpgSign = true;

        # ALIASES
        alias = {
          co = "checkout";
          st = "status";
          rh = "reset HEAD";
          rhh = "reset --hard HEAD";
          pu = "pull";
          up = "push";

          l = "!. ${githelpers} && pretty_git_log";
          la = "!git l --all";
          lr = "!git l -30";
          lra = "!git lr --all";
          lg = "!git l -G $1 -- $2";
          feature = "!sh -c 'git checkout --no-track -b $0 origin/main'";

          ruf = "!. ${githelpers} && remove_untracked_files";

          tree = "log --oneline --decorate --graph";

          # https://aaronbonner.io/post/80766268890/git-alias-to-simplify-setting-upstream-branch
          sup = "!git branch --set-upstream-to=origin/`git symbolic-ref --short HEAD`";
        };

        color.diff = "auto";
        color.status = "auto";
        color.branch = "auto";
        color.ui = true;

        push.default = "current";
        push.followTags = true;

        remote.pushDefault = "origin";

        branch.autoSetupRebase = "always";

        diff."gpg".binary = true;
        diff."gpg".textconv = "gpg -d --quiet --yes --compress-algo=none --no-encrypt-to --batch --use-agent";

        commit.verbose = true;

        init.defaultBranch = "main";

        pull.rebase = true;
        rebase.autoStash = true;

        protocol."file".allow = "always";

        filter."lfs".smudge = "git-lfs smudge -- %f";
        filter."lfs".process = "git-lfs filter-process";
        filter."lfs".required = true;
        filter."lfs".clean = "git-lfs clean -- %f";

        fetch.fsckObjects = true;
        receive.fsckObjects = true;
        transfer.fsckobjects = true;

        url."ssh://git@github.com/".insteadOf = "https://github.com/";
      };
    };
}
