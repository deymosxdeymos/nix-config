{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.teal-music;
  flake.darwinModules.teal-music =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
      inherit (lib.modules) mkIf;
      inherit (lib.options) mkEnableOption mkOption;
      inherit (lib.types) str;
    in
    {
      options.services.teal-music = {
        enable = mkEnableOption "Music app live status publishing to Teal";

        actor = mkOption {
          type = str;
          default = "deymos.dev";
          description = "AT Protocol account and login Keychain item account.";
        };

        pds = mkOption {
          type = str;
          default = "https://eurosky.social";
          description = "HTTPS origin of the account's Personal Data Server.";
        };

        keychainService = mkOption {
          type = str;
          default = "dev.deymos.teal-music";
          description = "Login Keychain service holding an AT Protocol app password.";
        };
      };

      config.environment.systemPackages =
        mkIf config.services.teal-music.enable
        <| singleton self.packages.${pkgs.stdenv.hostPlatform.system}.teal-music;

      config.launchd.user.agents.teal-music.serviceConfig = mkIf config.services.teal-music.enable {
        ProgramArguments = [
          (getExe self.packages.${pkgs.stdenv.hostPlatform.system}.teal-music)
          "--pds"
          config.services.teal-music.pds
          "--actor"
          config.services.teal-music.actor
          "--keychain-service"
          config.services.teal-music.keychainService
        ];
        RunAtLoad = true;
        KeepAlive = true;
        ThrottleInterval = 60;
        ProcessType = "Background";
        StandardOutPath = "${
          config.users.users.${config.system.primaryUser}.home
        }/Library/Logs/teal-music.log";
        StandardErrorPath = "${
          config.users.users.${config.system.primaryUser}.home
        }/Library/Logs/teal-music.log";
      };
    };
}
