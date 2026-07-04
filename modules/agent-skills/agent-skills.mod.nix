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
    };
}
