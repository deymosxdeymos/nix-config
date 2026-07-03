{ inputs, self, ... }:
{
  # HJEM WIRING
  # Replaces home-manager. hjem manages the user's home; hjem-rum provides the
  # `rum.programs.*` modules. All `flake.homeModules` are evaluated inside each
  # user via `hjem.extraModules`.
  flake.nixosModules.home =
    { lib, ... }:
    let
      inherit (lib.attrsets) attrValues;
    in
    {
      imports = [ inputs.hjem.nixosModules.hjem ];

      hjem.clobberByDefault = true;
      hjem.specialArgs = { inherit inputs self; };
      hjem.extraModules = [ inputs.hjem-rum.hjemModules.hjem-rum ] ++ attrValues self.homeModules;

      hjem.users.cfactoryai = {
        user = "cfactoryai";
        directory = "/home/cfactoryai";
      };
    };

  # BASE HOME
  flake.homeModules.home =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.modules) mkAliasOptionModule;
    in
    {
      # ncc pattern: lets home modules write `programs.foo` for `rum.programs.foo`.
      imports = singleton (mkAliasOptionModule [ "programs" ] [ "rum" "programs" ]);

      environment.sessionVariables = {
        EDITOR = "hx";
        VISUAL = "hx";
      };

      packages = [
        pkgs.jq
        pkgs.p7zip
        pkgs.unzip
        pkgs.zip
      ];
    };
}
