{ self, lib, ... }:
let
  inherit (lib.lists) concatMap;
  inherit (lib.strings) concatLines;

  forbidden.rules = [
    {
      commands = [
        "git add*"
        "git am*"
        "git apply*"
        "git branch -d*"
        "git branch -D*"
        "git branch --delete*"
        "git checkout*"
        "git cherry-pick*"
        "git clean*"
        "git commit*"
        "git init*"
        "git merge*"
        "git mv*"
        "git pull*"
        "git push*"
        "git rebase*"
        "git reset*"
        "git restore*"
        "git revert*"
        "git rm*"
        "git stash*"
        "git switch*"
        "git tag*"
        "git worktree*"
      ];
      justification = "Use `jj` for version control. Read-only `git` (log, diff, show, status, blame, merge-base, fetch) is fine.";
    }
    {
      commands = [
        "find /nix/store"
        "find /nix/store *"
        "find /nix/store/"
        "find /nix/store/ *"
      ];
      justification = "Do not `find` over the entire `/nix/store`. Search specific store paths obtained from the flake instead.";
    }
  ];

  instructions =
    [
      "In a repository without a `.jj` directory, run `jj git init --colocate` before changing history."
      "Use `jj describe`, `jj new`, `jj commit`, `jj squash`, `jj bookmark` and `jj git push` instead of their git equivalents."
      "Nix flakes only see files git knows about, so run `jj new` after creating files before evaluating a flake."
      "Prefer nix3 commands over nix2 commands."
    ]
    ++ (forbidden.rules |> map ({ justification, ... }: justification))
    |> map (instruction: ''
      - ${instruction}
    '')
    |> concatLines;
in
{
  flake.homeModules.default.imports = [
    self.homeModules.claude-code
    self.homeModules.codex
  ];

  flake.homeModules.codex =
    { lib, pkgs, ... }:
    let
      inherit (lib.strings)
        concatMapStringsSep
        removeSuffix
        splitString
        toJSON
        trim
        ;
    in
    {
      xdg.config.files."codex/config.toml".type = "copy";
      xdg.config.files."codex/config.toml".generator = pkgs.writers.writeTOML "codex-config.toml";
      xdg.config.files."codex/config.toml".value = {
        model = "gpt-6.1-terra";
        model_reasoning_effort = "low";

        commit_attribution = "";
        developer_instructions = instructions;

        history.persistence = "save-all";

        tui.screen_reader_detection_done = true;

        projects."/Users/deymos/Developer/gamgen".trust_level = "trusted";
      };

      xdg.config.files."codex/rules/default.rules".text =
        (
          forbidden.rules
          |> concatMapStringsSep "\n" (
            { justification, ... }@rule:
            rule.commands
            |> concatMapStringsSep "\n" (command: /* starlark */ ''
              prefix_rule(
                  pattern = ${
                    command
                    |> removeSuffix "*"
                    |> trim
                    |> splitString " "
                    |> toJSON
                  },
                  decision = "forbidden",
                  justification = ${toJSON justification},
              )
            '')
          )
        )
        + /* starlark */ ''
          prefix_rule(pattern = ["rex"], decision = "allow")
        '';
    };

  flake.homeModules.claude-code =
    { lib, pkgs, ... }:
    let
      inherit (lib.generators) toJSON;
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;

      worktreeCreate = pkgs.writeShellApplication {
        name = "claude-worktree-create";
        runtimeInputs = [
          pkgs.git
          pkgs.jq
          pkgs.jujutsu
        ];
        text = /* bash */ ''
          input=$(cat)
          name=$(jq --raw-output .name <<< "$input")
          cd "$(jq --raw-output .cwd <<< "$input")"

          if root=$(jj workspace root 2>/dev/null); then
            destination="$(dirname "$root")/$(basename "$root")-$name"
            jj workspace add --name "$name" "$destination" >&2
          else
            root=$(git rev-parse --show-toplevel)
            destination="$root/.claude/worktrees/$name"
            git worktree add -b "worktree-$name" "$destination" >&2
          fi

          echo "$destination"
        '';
      };

      worktreeRemove = pkgs.writeShellApplication {
        name = "claude-worktree-remove";
        runtimeInputs = [
          pkgs.git
          pkgs.jq
          pkgs.jujutsu
        ];
        text = /* bash */ ''
          path=$(jq --raw-output .worktree_path)

          if [ -d "$path/.jj" ]; then
            (cd "$path" && jj workspace forget) >&2
            rm -rf "$path"
          else
            git -C "$path" worktree remove --force "$path" >&2
            git branch -D "worktree-$(basename "$path")" >&2 || true
          fi
        '';
      };
    in
    {
      xdg.config.files."claude-code/CLAUDE.md".text = instructions;

      xdg.config.files."claude-code/settings.json".type = "copy";
      xdg.config.files."claude-code/settings.json".generator = toJSON { };
      xdg.config.files."claude-code/settings.json".value = {
        "$schema" = "https://json.schemastore.org/claude-code-settings.json";

        cleanupPeriodDays = 365 * 1000;

        model = "opus";
        modelSettings.claude-opus-5-5.autoCompactWindow = "auto";

        permissions.defaultMode = "bypassPermissions";
        skipDangerousModePermissionPrompt = true;
        permissions.deny =
          forbidden.rules |> concatMap (rule: rule.commands |> map (command: "Bash(${command})"));

        syncClaudeAiPlugins = false;
        syncClaudeAiSkills = false;
        env.CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
        env.DISABLE_ERROR_REPORTING = "1";
        env.DISABLE_TELEMETRY = "1";

        hooks.SessionStart = singleton {
          hooks = singleton {
            type = "command";
            command = "/bin/sh -c 'rex __internal session-start --agent claude 2>/dev/null || true'";
            timeout = 5;
          };
        };
        hooks.WorktreeCreate = singleton {
          hooks = singleton {
            type = "command";
            command = getExe worktreeCreate;
          };
        };
        hooks.WorktreeRemove = singleton {
          hooks = singleton {
            type = "command";
            command = getExe worktreeRemove;
          };
        };

        attribution.commit = "";
        attribution.pr = "";

        theme = "auto";
        tui = "fullscreen";

        awaySummaryEnabled = false;
      };
    };
}
