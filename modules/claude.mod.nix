{
  flake.homeModules.claude =
    { pkgs, ... }:
    {
      packages = [ pkgs.claude-code ];

      files.".claude/settings.json" = {
        type = "copy";
        source = ./claude-settings.json;
      };
    };
}
