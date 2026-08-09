{ lib, ... }:
{
  flake.homeModules.git =
    { pkgs, ... }:
    let
      inherit (lib.meta) getExe;
      fish = getExe pkgs.fish;
      gh = getExe pkgs.gh;
      git = getExe pkgs.git;
    in
    {
      packages = [
        pkgs.git
        pkgs.git-lfs
        pkgs.lazygit
      ];

      files.".gitconfig".text = /* gitconfig */ ''
        [user]
          email = galinnichola15@gmail.com
          name = deymosxdeymos
        [credential "https://github.com"]
          helper =
          helper = !${gh} auth git-credential
        [credential "https://gist.github.com"]
          helper =
          helper = !${gh} auth git-credential
        [init]
          defaultBranch = main
        [url "https://github.com/"]
          insteadOf = git@github.com:
        [branch]
          sort = -committerdate
        [column]
          ui = auto
        [core]
          editor = nvim
          fsmonitor = true
        [fetch]
          prune = true
          writeCommitGraph = true
        [pull]
          rebase = true
        [rebase]
          autoStash = true
          updateRefs = true
        [rerere]
          autoUpdate = true
          enabled = true
        [alias]
          fomo = !${fish} -c '${git} fetch origin (__git.default_branch); and ${git} rebase origin/(__git.default_branch) --autostash'
          lg = log --oneline --decorate --graph
        [filter "lfs"]
          clean = git-lfs clean -- %f
          smudge = git-lfs smudge -- %f
          process = git-lfs filter-process
          required = true
      '';

      xdg.config.files."git/ignore".text = ''
        .direnv/
        .dev/
      '';
    };
}
