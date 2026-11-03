{ self, ... }:
{
  flake.homeModules.default = self.homeModules.rust;
  flake.homeModules.rust =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.modules) mkIf;
      inherit (lib.strings) makeLibraryPath;
    in
    {
      environment.sessionVariables = {
        CARGO_NET_GIT_FETCH_WITH_CLI = "true";
        LIBRARY_PATH = mkIf pkgs.stdenv.hostPlatform.isDarwin <| makeLibraryPath <| singleton pkgs.libiconv;
        RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
      };

      packages = [
        pkgs.cargo
        pkgs.cargo-deny
        pkgs.cargo-expand
        pkgs.cargo-nextest
        pkgs.clippy
        pkgs.rustc
        pkgs.rustfmt
      ];
    };
}
