{
  # AGENT SKILLS
  # Single canonical skill set (vendored in ./skills) symlinked into every
  # agent tool's skill directory. `.claude/skills` mirrors `.agents/skills`;
  # edit skills in-repo and `nh os switch` to update all hosts.
  flake.homeModules.agent-skills =
    { ... }:
    {
      files.".agents/skills".source = ./skills;

      files.".claude/skills".source = ./skills;

      # claude-code reads user skills from $CLAUDE_CONFIG_DIR/skills, and
      # slop.mod.nix overrides CLAUDE_CONFIG_DIR to ~/.config/claude-code, so the
      # ~/.claude/skills link above is ignored. Mirror the set there too.
      files.".config/claude-code/skills".source = ./skills;
    };
}
