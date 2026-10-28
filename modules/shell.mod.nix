{ self, ... }:
{
  flake.homeModules.default.imports = [
    self.homeModules.atuin
    self.homeModules.direnv
    self.homeModules.starship
    self.homeModules.zoxide
  ];

  flake.homeModules.atuin =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
    in
    {
      packages = singleton pkgs.atuin;

      # Binds CTRL+R and UP.
      xdg.config.files."fish/conf.d/atuin.fish".text = /* fish */ ''
        if status is-interactive
            ${getExe pkgs.atuin} init fish | source
        end
      '';
    };

  flake.homeModules.direnv =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
    in
    {
      packages = singleton pkgs.direnv;

      xdg.config.files."direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";

      xdg.config.files."fish/conf.d/direnv.fish".text = /* fish */ ''
        if status is-interactive
            ${getExe pkgs.direnv} hook fish | source
        end
      '';
    };

  flake.homeModules.zoxide =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
    in
    {
      packages = singleton pkgs.zoxide;

      # `cd` and `cdi` are overridden by zoxide's smart jumping.
      xdg.config.files."fish/conf.d/zoxide.fish".text = /* fish */ ''
        ${getExe pkgs.zoxide} init fish --cmd cd | source
      '';
    };

  flake.homeModules.starship =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
    in
    {
      packages = singleton pkgs.starship;

      xdg.config.files."fish/conf.d/starship.fish".text = /* fish */ ''
        if status is-interactive
            ${getExe pkgs.starship} init fish | source
        end
      '';

      xdg.config.files."starship.toml".generator = pkgs.writers.writeTOML "starship.toml";
      xdg.config.files."starship.toml".value = {
        # Node shims can take longer than Starship's default 500ms to resolve.
        command_timeout = 2000;

        format = "$directory\${custom.scm}$all";

        buf.disabled = true;

        character.error_symbol = "[󰘧](bold red)";
        character.success_symbol = "[󰘧](bold green)";

        directory.truncate_to_repo = false;

        dotnet.detect_files = [
          "global.json"
          "Directory.Build.props"
          "Directory.Build.targets"
          "Packages.props"
        ];

        git_branch.symbol = " ";
        git_branch.truncation_length = 18;

        golang.symbol = " ";

        lua.symbol = " ";

        nix_shell.symbol = " ";

        # Only show Node for actual Node projects. This avoids unnecessary
        # `node --version` calls in repos that just happen to contain JS/TS files.
        nodejs.detect_extensions = [ ];
        nodejs.detect_files = [
          "package.json"
          ".node-version"
          ".nvmrc"
          ".tool-versions"
        ];
        nodejs.detect_folders = singleton "node_modules";

        package.disabled = true;
      };
    };
}
