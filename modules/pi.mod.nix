{ inputs, ... }:
{
  # PI CODING AGENT
  # Package comes from lukasl-dev/pi.nix (npm-built, cached on pi.cachix.org).
  # This repo uses hjem rather than home-manager, so pi.nix's home module can't
  # be imported directly; instead the config tree is laid out declaratively
  # under ~/.pi/agent, mirroring the chezmoi dotfiles. pi auto-discovers the
  # extensions/ and agents/ directories.
  flake.homeModules.pi =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      packages = [ inputs.pi.packages.${system}.coding-agent ];

      # pi rewrites both settings files at runtime (e.g. lastChangelogVersion),
      # so they must be writable copies rather than read-only store symlinks.
      files.".pi/agent/settings.json".type = "copy";
      files.".pi/agent/settings.json".source = ./pi/settings.json;

      files.".pi/agent/extensions".source = ./pi/extensions;

      files.".pi/agent/agents".source = ./pi/agents;
    };
}
