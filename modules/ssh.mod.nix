{ self, ... }:
{
  flake.darwinModules.default = self.darwinModules.ssh-known-hosts;
  flake.darwinModules.ssh-known-hosts = {
    programs.ssh.knownHosts."github.com".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
  };

  flake.homeModules.default = self.homeModules.ssh-client;
  flake.homeModules.ssh-client =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.attrsets) filterAttrs mapAttrs;
      inherit (lib.generators) toSSHConfig;
      inherit (lib.meta) getExe';
    in
    {
      xdg.config.files."fish/conf.d/ssh.fish".text = /* fish */ ''
        alias mosh '${getExe' pkgs.mosh "mosh"} --no-init'
      '';

      packages = [
        pkgs.mosh
        pkgs.openssh
      ];

      xdg.cache.files."ssh".type = "directory";

      xdg.config.files."ssh/config".generator = toSSHConfig;
      xdg.config.files."ssh/config".value.Host =
        (
          self.machines
          |> filterAttrs (_: { ssh, ... }: ssh.enable)
          |> mapAttrs (
            _:
            { ssh, ... }:
            filterAttrs (_: value: value != null) {
              User = ssh.user;
              HostName = ssh.hostName;
              Port = ssh.port;
            }
          )
        )
        // {
          "*" = {
            SetEnv = "COLORTERM=truecolor TERM=xterm-256color";

            IdentityFile = "~/.ssh/id_ed25519";

            ControlMaster = "auto";
            ControlPersist = "60m";
            ControlPath = "${config.xdg.cache.directory}/ssh/%r@%n:%p";
          };
        };
    };
}
