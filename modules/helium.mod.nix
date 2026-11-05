{
  self,
  inputs,
  lib,
  ...
}:
let
  inherit (lib.attrsets)
    attrNames
    concatMapAttrs
    filterAttrs
    getAttr
    hasAttr
    mapAttrsToList
    optionalAttrs
    ;
  inherit (lib.lists) filter foldr singleton;
  inherit (lib.strings) hasInfix;
  inherit (lib.trivial)
    const
    flip
    importJSON
    warn
    ;

  extensions."1password".id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";

  extensions.ublock-origin =
    let
      assets = importJSON "${inputs.ublock}/assets/assets.json";

      filterLists =
        (
          assets
          |> filterAttrs (_: spec: (spec.content or null) == "filters" && (spec.group or null) != "regions")
          |> flip removeAttrs [
            "ublock-experimental"
          ]
          |> attrNames
        )
        ++ [
          "user-filters"

          "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/BrowseWebsitesWithoutLoggingIn.txt"
          "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/ClearURLs%20for%20uBo/clear_urls_uboified.txt"
          "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/LegitimateURLShortener.txt"
          "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/annoyance_list.txt"
          "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/click2load.txt"
        ];
    in
    {
      id = "blockjmkbacgjkknlgpkjjiijinjdanf";
      preinstalled = true;

      settings.toolbar_pin = "force_pinned";

      policy.userSettings = [
        [
          "suspendUntilListsAreLoaded"
          "true"
        ]
        [
          "userFiltersTrusted"
          "true"
        ]
      ];

      policy.toOverwrite.filterLists =
        filter (name: !(hasInfix "://" name || name == "user-filters" || hasAttr name assets)) filterLists
        |> foldr (name: warn "helium: unknown ublock filter list: ${name}") filterLists;

      policy.toOverwrite.filters = [
        "@@||google.com^"
        "@@||googleapis.com^"
        "@@||gstatic.com^"
        "@@||googleusercontent.com^"

        ''||youtube.com/shorts/$document,uritransform=/^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([^\/?#]+)/https:\/\/www.youtube.com\/watch?v=\$1/''

        "@@||youtube.com/embed/$frame"
        "@@||youtube-nocookie.com/embed/$frame"
      ];
    };

  extensions.sponsorblock.id = "mnjggcdmjocbbbhaepdhchncahnbgone";

  extensions.avec.id = "kggjnhfbblkeaobciljmjicfmmbgdhmk";
  extensions.control-panel-for-twitter.id = "kpmjjdhbcfebfjgdnpjagcndoelnidfj";
  extensions.refined-github.id = "hlepfoohegkhhmjieoechaddaejaokhf";

  policy = {
    ExtensionInstallForcelist =
      extensions
      |> filterAttrs (_: extension: !(extension.preinstalled or false))
      |> mapAttrsToList (const <| getAttr "id");

    ExtensionInstallSources = singleton "https://services.helium.imput.net/*";

    ExtensionSettings =
      extensions
      |> concatMapAttrs (
        _: extension: optionalAttrs (extension ? settings) { ${extension.id} = extension.settings; }
      );

    "3rdparty".extensions =
      extensions
      |> concatMapAttrs (
        _: extension: optionalAttrs (extension ? policy) { ${extension.id} = extension.policy; }
      );
  };
in
{
  flake.darwinModules.default = self.darwinModules.helium;
  flake.darwinModules.helium =
    { lib, pkgs, ... }:
    let
      inherit (lib.attrsets) mapAttrsToList;
      inherit (lib.generators) toPlist;
      inherit (lib.lists) singleton;
      inherit (lib.strings) concatLines escapeShellArg;

      files = {
        "net.imput.helium.plist" = policy;
      }
      // (
        policy."3rdparty".extensions
        |> concatMapAttrs (
          id: extensionPolicy: { "net.imput.helium.extensions.${id}.plist" = extensionPolicy; }
        )
      );
    in
    {
      homebrew.casks = singleton "helium-browser";

      system.activationScripts.postActivation.text = /* bash */ ''
        echo "installing helium policies..."

        /bin/mkdir -p "/Library/Managed Preferences"

        ${
          files
          |> mapAttrsToList (
            name: value:
            "/usr/bin/install -m 644 ${
              pkgs.writeText name <| toPlist { escape = true; } value
            } ${escapeShellArg "/Library/Managed Preferences/${name}"}"
          )
          |> concatLines
        }

        /usr/bin/killall cfprefsd || true
      '';
    };
}
