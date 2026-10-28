{ lib, ... }:
let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types)
    lazyAttrsOf
    nullOr
    port
    str
    submodule
    ;
in
{
  options.flake.people = mkOption {
    type =
      lazyAttrsOf
      <| submodule (
        { name, ... }:
        {
          options = {
            name = mkOption {
              type = str;
              default = name;
              description = "Display name.";
            };

            email = mkOption {
              type = str;
              description = "Primary email address.";
            };

            ssh.key = mkOption {
              type = str;
              description = "SSH public key.";
            };
          };
        }
      );
    default = { };
    description = "People.";
  };

  options.flake.machines = mkOption {
    type =
      lazyAttrsOf
      <| submodule (
        { name, ... }:
        {
          options = {
            ssh.enable = mkEnableOption "an SSH client entry for this machine";

            ssh.hostName = mkOption {
              type = str;
              default = name;
              description = "Host name to connect to.";
            };

            ssh.user = mkOption {
              type = nullOr str;
              default = null;
              description = "User to connect as.";
            };

            ssh.port = mkOption {
              type = nullOr port;
              default = null;
              description = "Port to connect to.";
            };
          };
        }
      );
    default = { };
    description = "Machines.";
  };

  config.flake.people.self = {
    name = "deymosxdeymos";
    email = "galinnichola15@gmail.com";
    ssh.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILOErW6L5IBxPqNuga/C+dIPfd3tbWuihI8BRZmK4yOV";
  };

  config.flake.machines.devbox.ssh = {
    enable = true;
    hostName = "devbox.tail8ece44.ts.net";
    user = "deymos";
  };

  config.flake.machines.devbox-admin.ssh = {
    enable = true;
    hostName = "devbox.tail8ece44.ts.net";
    user = "cfaicollabs";
  };
}
