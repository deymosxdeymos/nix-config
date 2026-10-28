{ inputs, self, ... }:
{
  flake.homeModules.default = self.homeModules.home;
  flake.homeModules.home =
    { config, ... }:
    {
      # FORCE XDG ENV VARS
      # hjem only exports XDG_*_HOME when config value != option default.
      # Setting them directly bypasses hjem's conditional logic.
      environment.sessionVariables = {
        XDG_CACHE_HOME = "${config.directory}/.cache";
        XDG_CONFIG_HOME = "${config.directory}/.config";
        XDG_DATA_HOME = "${config.directory}/.local/share";
        XDG_STATE_HOME = "${config.directory}/.local/state";
      };
    };

  flake.darwinModules.default = self.darwinModules.home;
  flake.darwinModules.home =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.attrsets) mapAttrsToList;
      inherit (lib.lists) singleton;
      inherit (lib.modules) mkAliasOptionModule;
      inherit (lib.strings) concatStringsSep escapeShellArg;
    in
    {
      imports = [
        inputs.hjem.darwinModules.hjem
        (mkAliasOptionModule [ "home" ] [ "hjem" ])
      ];

      home.specialArgs = { inherit lib; };

      home.clobberByDefault = true;

      # SESSION VARIABLES
      # Exported through launchd so GUI apps and every shell they spawn see them.
      launchd.user.envVariables =
        config.home.users.${config.system.primaryUser}.environment.sessionVariables;

      launchd.user.agents.user-environment.serviceConfig = {
        RunAtLoad = true;
        ProgramArguments =
          singleton
          <| "${pkgs.writeShellScript "user-environment" /* bash */ ''
            set -euo pipefail

            ${
              config.launchd.user.envVariables
              |> mapAttrsToList (
                name: value: "/bin/launchctl setenv ${escapeShellArg name} ${escapeShellArg value}"
              )
              |> concatStringsSep "\n"
            }
          ''}";
      };
    };
}
