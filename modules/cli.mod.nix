{ self, ... }:
{
  flake.homeModules.default = self.homeModules.cli;
  flake.homeModules.cli =
    { pkgs, ... }:
    {
      packages = [
        pkgs._7zz
        pkgs.fd
        pkgs.fzf
        pkgs.glslang
        pkgs.jq
        pkgs.nodejs
        pkgs.python312
        pkgs.uv
        pkgs.xcodegen
      ];
    };
}
