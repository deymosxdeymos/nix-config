{ inputs, self, ... }:
{
  flake.homeModules.default = self.homeModules.home;
  flake.homeModules.home =
    { config, ... }:
    {
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
