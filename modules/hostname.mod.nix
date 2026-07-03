{
  flake.nixosModules.hostname =
    { ... }:
    {
      networking.hostName = "thinkpad";
      networking.networkmanager.enable = true;
    };
}
