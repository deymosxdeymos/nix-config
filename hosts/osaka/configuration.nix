{
  inputs,
  lib,
  self,
  ...
}:
let
  inherit (lib.attrsets) attrValues removeAttrs;
  inherit (lib.lists) singleton;
in
{
  networking.hostName = "osaka";

  # HOME (hjem)
  # Every home module except the GUI-only ones. Wired inline (rather than the
  # shared `home` nixos module) so the server stays isolated from thinkpad.
  imports = singleton inputs.hjem.nixosModules.hjem;

  hjem.clobberByDefault = true;
  hjem.specialArgs = { inherit inputs self; };
  hjem.extraModules =
    singleton inputs.hjem-rum.hjemModules.hjem-rum
    ++ attrValues (removeAttrs self.homeModules [
      "browser"
      "ghostty"
    ]);
  hjem.users.cfactoryai = {
    user = "cfactoryai";
    directory = "/home/cfactoryai";
  };

  # primary-user adds cfactoryai to the networkmanager group, but this server has
  # no NetworkManager (static networking); declare the group so it resolves.
  users.groups.networkmanager = { };

  # SSH
  # Key-only. Host keys live on the persistent bcachefs volume so they survive
  # the impermanence wipe (and give agenix a stable identity later).
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.hostKeys = [
    {
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
    {
      path = "/persist/etc/ssh/ssh_host_rsa_key";
      type = "rsa";
      bits = 4096;
    }
  ];

  users.users.root.openssh.authorizedKeys.keys = singleton self.keys.deymosxdeymos;
  users.users.cfactoryai.openssh.authorizedKeys.keys = singleton self.keys.deymosxdeymos;

  # NETWORK
  # Static, mirrored from the droplet's cloud-init (DO SGP1). Interface names are
  # pinned off so eth0/eth1 stay stable after the switch to NixOS.
  networking.usePredictableInterfaceNames = false;
  networking.useDHCP = false;

  networking.nameservers = [
    "67.207.67.2"
    "67.207.67.3"
  ];

  networking.defaultGateway = {
    address = "167.71.208.1";
    interface = "eth0";
  };
  networking.defaultGateway6 = {
    address = "2400:6180:0:d2::1";
    interface = "eth0";
  };

  networking.interfaces.eth0 = {
    ipv4.addresses = [
      {
        address = "167.71.218.48";
        prefixLength = 20;
      }
      {
        address = "10.15.0.5";
        prefixLength = 16;
      }
    ];
    ipv6.addresses = singleton {
      address = "2400:6180:0:d2:0:2:fd9c:4000";
      prefixLength = 64;
    };
  };

  networking.interfaces.eth1.ipv4.addresses = singleton {
    address = "10.104.0.2";
    prefixLength = 20;
  };

  # IMPERMANENCE
  # Root is a tmpfs wiped each boot; only these survive on the bcachefs /persist.
  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/tailscale"
      "/home"
    ];

    files = [
      "/etc/machine-id"
    ];
  };

  system.stateVersion = "26.05";
}
