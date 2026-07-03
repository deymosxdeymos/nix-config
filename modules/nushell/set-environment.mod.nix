{
  # Translates the NixOS session environment into a nushell script, so nushell
  # login shells get the same env vars as bash/zsh (which source /etc/set-environment).
  # From ncc's nushell nixosModule — minus the `crash` shell and the extraInit hash
  # assertion, which are ncc-internal.
  flake.nixosModules.nushell-env =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.attrsets) mapAttrs mapAttrsToList zipAttrsWith;
      inherit (lib.lists)
        concatLists
        concatMap
        reverseList
        toList
        ;
      inherit (lib.strings)
        concatLines
        concatStringsSep
        replaceStrings
        splitString
        ;
      inherit (lib.trivial) const;
    in
    {
      system.build.setEnvironmentNu =
        let
          absoluteVariables = config.environment.variables |> mapAttrs (const toList);

          suffixedVariables =
            config.environment.profileRelativeEnvVars
            |> mapAttrs (
              const (
                suffixes:
                config.environment.profiles |> concatMap (profile: map (suffix: "${profile}${suffix}") suffixes)
              )
            );

          allVariables = zipAttrsWith (const concatLists) [
            absoluteVariables
            suffixedVariables
          ];

          nuString =
            value:
            /* nu */ ''$"${
              value
              |>
                replaceStrings
                  [
                    "\${XDG_STATE_HOME}"
                    "\$HOME"
                    "\${HOME}"
                    "\$USER"
                    "\${USER}"
                  ]
                  [
                    "($env.XDG_STATE_HOME? | default ($env.HOME + '/.local/state'))"
                    "($env.HOME)"
                    "($env.HOME)"
                    "($env.USER)"
                    "($env.USER)"
                  ]
            }"'';

          assignments =
            allVariables
            |> mapAttrsToList (
              name: segments:
              if name == "PATH" then
                /* nu */ ''
                  $env.PATH = [
                  ${segments |> concatMap (splitString ":") |> map (segment: "  ${nuString segment}") |> concatLines}
                  ]
                ''
              else
                /* nu */ ''
                  $env.${name} = ${nuString <| concatStringsSep ":" segments}
                ''
            )
            |> concatLines;

          extraInitNu = /* nu */ ''
            # Equivalent to the current NixOS environment.extraInit.
            $env.PATH = $env.PATH | prepend ${nuString "${config.security.wrapperDir}"}

            $env.NIX_USER_PROFILE_DIR = $"/nix/var/nix/profiles/per-user/($env.USER)"
            $env.NIX_PROFILES = ${
              config.environment.profiles |> reverseList |> concatStringsSep " " |> nuString
            }
          '';
        in
        pkgs.writeText "set-environment.nu" ''
          if ($env.__NIXOS_SET_ENVIRONMENT_DONE? | is-not-empty) { } else {
          $env.__NIXOS_SET_ENVIRONMENT_DONE = "1"
          ${assignments}
          ${extraInitNu}
          }
        '';
    };
}
