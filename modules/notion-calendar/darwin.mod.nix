{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.notion-calendar-icon;
  flake.darwinModules.notion-calendar-icon =
    { config, lib, pkgs, ... }:
    let
      inherit (lib.meta) getExe;
    in
    {
      launchd.user.agents.notion-calendar-icon.serviceConfig = {
        ProgramArguments = [
          (getExe self.packages.${pkgs.stdenv.hostPlatform.system}.set-app-icon)
          "/Applications/Notion Calendar.app"
          "${./cron-original.png}"
          "${config.users.users.${config.system.primaryUser}.home}/Library/Application Support/nix-app-icons/notion-calendar"
        ];
        RunAtLoad = true;
        StartInterval = 60;
        ProcessType = "Background";
        StandardErrorPath = "${config.users.users.${config.system.primaryUser}.home}/Library/Logs/notion-calendar-icon.log";
      };
    };
}
