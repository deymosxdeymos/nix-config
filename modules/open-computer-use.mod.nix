{ self, ... }:
{
  # OPEN COMPUTER USE
  # A Computer Use MCP server / CLI for controlling desktop apps over AT-SPI2.
  # Codex gets it as a native stdio MCP server (see modules/slop.mod.nix). pi has
  # no MCP, so it drives the same runtime through the upstream skill, which calls
  # the `ocu` CLI. The package puts `open-computer-use` / `ocu` on PATH for both.
  flake.homeModules.open-computer-use =
    { pkgs, ... }:
    let
      open-computer-use = self.packages.${pkgs.stdenv.hostPlatform.system}.open-computer-use;
    in
    {
      packages = [ open-computer-use ];

      files.".pi/agent/skills/open-computer-use".source = open-computer-use.skill;
    };
}
