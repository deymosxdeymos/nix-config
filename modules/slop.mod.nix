{ self, lib, ... }:
let
  inherit (lib.lists) concatMap singleton;
  inherit (lib.strings) concatLines;

  forbidden.rules = [
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
    singleton "Prefer nix3 commands over nix2 commands."
    ++ (forbidden.rules |> map ({ justification, ... }: justification))
    |> map (instruction: /* markdown */ ''
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
    { lib, ... }:
    let
      inherit (lib.generators) toJSON;
      inherit (lib.lists) singleton;
    in
    {
      xdg.config.files."claude-code/CLAUDE.md".text = instructions;

      xdg.config.files."claude-code/settings.json".type = "copy";
      xdg.config.files."claude-code/settings.json".generator = toJSON { };
      xdg.config.files."claude-code/settings.json".value = {
        "$schema" = "https://json.schemastore.org/claude-code-settings.json";

        cleanupPeriodDays = 365 * 1000;

        model = "opus";

        permissions.defaultMode = "bypassPermissions";
        skipDangerousModePermissionPrompt = true;
        permissions.deny =
          forbidden.rules |> concatMap (rule: rule.commands |> map (command: "Bash(${command})"));

        autoMemoryEnabled = false;

        syncClaudeAiPlugins = false;
        syncClaudeAiSkills = false;

        env.CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
        env.DISABLE_ERROR_REPORTING = "1";

        hooks.SessionStart = singleton {
          hooks = singleton {
            type = "command";
            command = "/bin/sh -c 'rex __internal session-start --agent claude 2>/dev/null || true'";
            timeout = 5;
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
