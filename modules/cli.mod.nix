{ self, ... }:
{
  flake.homeModules.default = self.homeModules.cli;
  flake.homeModules.cli =
    { pkgs, ... }:
    {
      packages = [
        pkgs._7zz
        (pkgs.bun.overrideAttrs (finalAttrs: {
          version = "1.4.4";
          src = pkgs.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-darwin-aarch64.zip";
            hash = "sha256-wkDX8My5DCY6hJ/NsJt+5iYw2SE0jtaq/ahrnVd7xRA=";
          };
        }))
        pkgs.curl
        pkgs.devenv
        pkgs.diffutils
        pkgs.fd
        pkgs.findutils
        pkgs.fzf
        pkgs.gawk
        pkgs.glslang
        pkgs.gnused
        pkgs.gnutar
        pkgs.gzip
        pkgs.jq
        pkgs.nodejs
        pkgs.openssl
        pkgs.python312
        pkgs.uutils-coreutils-noprefix
        pkgs.uv
        pkgs.xcodegen
      ];
    };
}
