{ lib, ... }:
let
  inherit (lib.lists) singleton;
in
{
  imports =
    singleton
    <| lib.systems.darwinSystem "air" {
      system.primaryUser = "deymos";
      users.users.deymos = {
        name = "deymos";
        home = "/Users/deymos";
      };
      home.users.deymos = { };

      services.teal-music.enable = true;

      nixpkgs.hostPlatform = "aarch64-darwin";
      system.stateVersion = 6;
    };
}
