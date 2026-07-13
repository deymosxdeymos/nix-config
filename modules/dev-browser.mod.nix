{ self, ... }:
{
  # DEV BROWSER
  # Browser automation CLI (Rust front-end + Node/Playwright daemon in a QuickJS
  # sandbox). It has no MCP server; agents drive it through its CLI, guided by the
  # upstream skill. Install that skill for both pi and codex, and put `dev-browser`
  # on PATH. The package is fully self-contained (nix-provided daemon + Chromium),
  # so no `dev-browser install` / network step is ever needed.
  flake.homeModules.dev-browser =
    { pkgs, ... }:
    let
      dev-browser = self.packages.${pkgs.stdenv.hostPlatform.system}.dev-browser;
    in
    {
      packages = [ dev-browser ];

      files.".pi/agent/skills/dev-browser".source = dev-browser.skill;

      # CODEX_HOME is relocated to ~/.config/codex (see modules/slop.mod.nix), so
      # codex discovers skills under there rather than ~/.codex.
      xdg.config.files."codex/skills/dev-browser".source = dev-browser.skill;
    };
}
