{
  config,
  lib,
  moduleLocation,
  ...
}:
let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.lists) singleton;
  inherit (lib.options) mkOption;
  inherit (lib.fixedPoints) fix;
  inherit (lib.types) deferredModule lazyAttrsOf;

  wrap =
    {
      kind,
      class ? null,
    }:
    name: value:
    fix (module: {
      _file = "${toString moduleLocation}#${kind}.${name}";
      key = module._file;

      ${if class == null then null else "_class"} = class;

      imports = singleton value;
    });
in
{
  options.flake.darwinModules = mkOption {
    type = lazyAttrsOf deferredModule;
    default = { };
    apply =
      mapAttrs
      <| wrap {
        kind = "darwinModules";
        class = "darwin";
      };
    description = "Darwin modules.";
  };

  options.flake.homeModules = mkOption {
    type = lazyAttrsOf deferredModule;
    default = { };
    apply =
      mapAttrs
      <| wrap {
        kind = "homeModules";
        class = "hjem";
      };
    description = "Home modules.";
  };

  config.flake.darwinModules =
    config.flake.homeModules |> mapAttrs (_: module: { home.extraModules = singleton module; });
}
