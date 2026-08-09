{ lib, self, ... }:
let
  inherit (lib.strings) toJSON;
  inherit (lib.meta) getExe';
in
{
  # PI CODING AGENT
  # Auto-updates from npm on each launch (like opencode/codex) rather than being
  # pinned through a nix flake input. This repo uses hjem rather than
  # home-manager, so the config tree is laid out declaratively under ~/.pi/agent,
  # mirroring the chezmoi dotfiles. pi auto-discovers the extensions/ and agents/
  # directories.
  flake.homeModules.pi =
    { pkgs, ... }:
    let
      open-computer-use = self.packages.${pkgs.stdenv.hostPlatform.system}.open-computer-use;
      mcpConfig =
        pkgs.writeText "pi-mcp.json"
        <| toJSON {
          mcp = {
            toolMode = "proxy";
            startup = "lazy";
            servers = {
              chrome-devtools = {
                type = "local";
                command = [
                  (getExe' pkgs.nodejs "npm")
                  "exec"
                  "--yes"
                  "--package"
                  "chrome-devtools-mcp@latest"
                  "--"
                  "chrome-devtools-mcp"
                ];
                enabled = false;
                timeout = 60000;
              };
              open-computer-use = {
                type = "local";
                command = [
                  (getExe' open-computer-use "open-computer-use")
                  "mcp"
                ];
                enabled = false;
                timeout = 60000;
              };
            };
          };
        };
    in
    {
      packages = [
        (pkgs.writeScriptBin "pi" /* bash */ ''
          #!${getExe' pkgs.bash "bash"}
          # npm runs a package's postinstall as `sh -c 'node ...'`, so `node`
          # must be on PATH or the script dies with 127. Nothing else adds nodejs
          # to PATH here.
          export PATH="${pkgs.nodejs}/bin''${PATH:+:$PATH}"
          exec "${getExe' pkgs.nodejs "npm"}" exec --yes --package "@earendil-works/pi-coding-agent@latest" -- "pi" "$@"
        '')
      ];

      # pi rewrites both settings files at runtime (e.g. lastChangelogVersion),
      # so they must be writable copies rather than read-only store symlinks.
      files.".pi/agent/settings.json".type = "copy";
      files.".pi/agent/settings.json".source = ./pi/settings.json;

      files.".pi/agent/mcp.json".type = "copy";
      files.".pi/agent/mcp.json".source = mcpConfig;

      files.".pi/agent/pi-sub-bar-settings.json".type = "copy";
      files.".pi/agent/pi-sub-bar-settings.json".source = ./pi/pi-sub-bar-settings.json;

      files.".pi/agent/extensions".source = ./pi/extensions;
    };
}
