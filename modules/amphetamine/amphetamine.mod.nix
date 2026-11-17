{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.amphetamine;
  flake.darwinModules.amphetamine =
    { config, ... }:
    {
      environment.etc."sudoers.d/amphetamine_PowerProtect" = {
        text = /* sudoers */ ''
          ${config.system.primaryUser} ALL=(root) NOPASSWD: /usr/bin/pmset -a disablesleep 1, /usr/bin/pmset -a disablesleep 0
        '';
      };

      home.users.${config.system.primaryUser}.files."Library/Application Scripts/com.if.Amphetamine/powerProtect.scpt" =
        {
          source = ./powerProtect.scpt;
          type = "copy";
        };

      homebrew.masApps.Amphetamine = 937984704;
    };
}
