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

  # PASSWORDS
  extensions."1password".id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";

  # UNSLOP
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
          "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/privacy_essentials.txt"
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

      policy.toOverwrite.filters =
        # YOUTUBE
        [
          # SHORTS -> WATCH
          ''||youtube.com/shorts/$document,uritransform=/^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([^\/?#]+)/https:\/\/www.youtube.com\/watch?v=\$1/''

          # TODO: Allow youtube embeds without click2load'ing, as they are broken: https://github.com/uBlockOrigin/uBlock-issues/issues/3868
          "@@||youtube.com/embed/$frame"
          "@@||youtube-nocookie.com/embed/$frame"
        ]
        # OLD REDDIT
        ++ [
          "@@||reddit.com/media$document,uritransform"
          "@@||reddit.com/video/$document,uritransform"
          "@@||reddit.com/mod$document,uritransform"
          "@@||reddit.com/poll$document,uritransform"
          "@@||reddit.com/settings$document,uritransform"
          "@@||reddit.com/topics$document,uritransform"
          "@@||reddit.com/community-points$document,uritransform"
          "@@||reddit.com/appeal$document,uritransform"
          "@@||reddit.com/appeals$document,uritransform"
          "@@||reddit.com/notifications$document,uritransform"
          "@@||reddit.com/message/compose/$document,uritransform"
          "@@||reddit.com/mail^$document,uritransform"
          "@@||reddit.com/answers^$document,uritransform"
          ''@@/^https:\/\/\w*\.?reddit\.com\/r\/[A-Za-z0-9_]+\/s\//$document,uritransform''
          ''@@/^https:\/\/\w*\.?reddit\.com\/.*[?&]new_reddit=true(?:$|[&#])/$document,uritransform''

          ''||reddit.com/gallery/$document,uritransform=/^https:\/\/(?:www\.|np\.|amp\.|i\.)?reddit\.com\/gallery\/(.*)/https:\/\/old.reddit.com\/comments\/\$1/''
          ''||reddit.com^$document,uritransform=/^https:\/\/(?:www\.|np\.|amp\.|i\.)?reddit\.com\/(?!gallery\/)/https:\/\/old.reddit.com\//''

          "old.reddit.com##:is(#eu-cookie-policy, #redesign-beta-optin-btn)"
        ];
    };

  # YOUTUBE
  extensions.dearrow.id = "enamippconapkdmgfgjchkhakpfinmaj";
  extensions.sponsorblock.id = "mnjggcdmjocbbbhaepdhchncahnbgone";

  # VISUALS
  extensions.avec.id = "kggjnhfbblkeaobciljmjicfmmbgdhmk";
  extensions.control-panel-for-twitter.id = "kpmjjdhbcfebfjgdnpjagcndoelnidfj";
  extensions.refined-github.id = "hlepfoohegkhhmjieoechaddaejaokhf";

  # Unlike ncc, there is no ExtensionInstallBlocklist, so manually loaded
  # extensions (such as the unpacked browser-control one) keep working.
  policy = {
    # EXTENSIONS
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

      # POLICY
      # ncc writes these with nix-darwin's modular services, which aren't merged
      # upstream yet, so they are installed from an activation script instead.
      system.activationScripts.postActivation.text = /* bash */ ''
        echo "installing helium policies..."

        /bin/mkdir -p "/Library/Managed Preferences"

        ${
          files
          |> mapAttrsToList (
            name: value:
            "/usr/bin/install -m 644 ${pkgs.writeText name <| toPlist { escape = true; } value} ${escapeShellArg "/Library/Managed Preferences/${name}"}"
          )
          |> concatLines
        }
      '';
    };
}
