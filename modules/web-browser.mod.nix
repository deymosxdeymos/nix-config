{
  flake.nixosModules.browser =
    {
      inputs,
      pkgs,
      ...
    }:
    let
      json = pkgs.formats.json { };

      chromiumExtension =
        id: "${id};https://clients2.google.com/service/update2/crx";

      ublockId = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
      bitwardenId = "nngceckbapebfimnlniiiahkandclblb";

      # UNSLOP
      darkReaderId = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
      sponsorBlockId = "mnjggcdmjocbbbhaepdhchncahnbgone";
      deArrowId = "enamippconapkdmgfgjchkhakpfinmaj";
      refinedGithubId = "hlepfoohegkhhmjieoechaddaejaokhf";
      vimiumCId = "hfjbmagddngcpeloejdejnfgbamkjaeg";
      consentOMaticId = "mdjildafknihdffpkfmmpnpoiajfjnjd";
      violentMonkeyId = "jinjaccalgkegednnccohejagnlnfdag";
      kagiId = "cdglnehniifkbagbbombnjghhcihifij";

      forceInstalledIds = [
        ublockId
        bitwardenId
        darkReaderId
        sponsorBlockId
        deArrowId
        refinedGithubId
        vimiumCId
        consentOMaticId
        violentMonkeyId
        kagiId
      ];

      # BOOKMARK HELPERS
      mkFolder = name: children: { inherit name children; };

      mkBookmark = name: url: { inherit name url; };

      mkScriptlet =
        name: javascript:
        mkBookmark name (
          "javascript:"
          + "{${javascript}}"
          + /* javascript */ ''
            void undefined;
          ''
        );

      heliumPolicies = {
        DefaultBrowserSettingEnabled = false;
        DeveloperToolsAvailability = 1;
        BatterySaverModeAvailability = 0;

        # See ncc: preference-level "restore on startup" can't be forced on a
        # consumer machine (HMAC-tracked pref + AD-only policy), so this is
        # best-effort only.
        RestoreOnStartup = 1;

        ExtensionInstallBlocklist = [
          "*"
        ];

        ExtensionInstallAllowlist = forceInstalledIds;

        ExtensionInstallForcelist = map chromiumExtension forceInstalledIds;

        ExtensionInstallSources = [
          "https://services.helium.imput.net/*"
        ];

        ExtensionSettings = {
          ${ublockId}.toolbar_pin = "force_pinned";
          ${bitwardenId}.toolbar_pin = "force_pinned";
        };

        "3rdparty".extensions.${ublockId} = {
          toOverwrite.filterLists = [
            "user-filters"
            "easylist"
            "easyprivacy"
            "plowe-0"
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-quick-fixes"
            "ublock-unbreak"
            "urlhaus-1"
            "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/BrowseWebsitesWithoutLoggingIn.txt"
            "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/ClearURLs%20for%20uBo/clear_urls_uboified.txt"
            "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/LegitimateURLShortener.txt"
            "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/annoyance_list.txt"
            "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/click2load.txt"
            "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/privacy_essentials.txt"
          ];

          toOverwrite.filters = [
            # YOUTUBE SHORTS -> WATCH
            ''||youtube.com/shorts/$document,uritransform=/^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([^\/?#]+)/https:\/\/www.youtube.com\/watch?v=\$1/''

            "@@||youtube.com/embed/$frame"
            "@@||youtube-nocookie.com/embed/$frame"

            # OLD REDDIT
            "@@||reddit.com/media$document"
            "@@||reddit.com/mod$document"
            "@@||reddit.com/poll$document"
            "@@||reddit.com/settings$document"
            "@@||reddit.com/topics$document"
            "@@||reddit.com/community-points$document"
            "@@||reddit.com/appeal$document"
            "@@||reddit.com/appeals$document"
            "@@||reddit.com/notifications$document"
            "@@||reddit.com/message/compose/$document"
            "@@||reddit.com/mail^$document"
            "@@||reddit.com/answers^$document"
            "@@||reddit.com/r/subreddit^$document"
            ''@@/^https:\/\/\w*\.?reddit\.com\/r\/[A-Za-z0-9_]+\/s\//$document''
            ''@@/^https:\/\/\w*\.?reddit\.com\/.*[?&]new_reddit=true(?:$|[&#])/$document''
            ''||reddit.com/gallery/$document,uritransform=/^https:\/\/(?:www\.|np\.|amp\.|i\.)?reddit\.com\/gallery\/(.*)/https:\/\/old.reddit.com\/comments\/\$1/''
            ''||reddit.com^$document,uritransform=/^https:\/\/(?:www\.|np\.|amp\.|i\.)?reddit\.com\/(?!gallery\/)/https:\/\/old.reddit.com\//''
            "old.reddit.com##:is(#eu-cookie-policy, #redesign-beta-optin-btn)"
          ];

          userSettings = [
            [
              "userFiltersTrusted"
              "true"
            ]
          ];
        };

        PasswordManagerEnabled = false;

        # SEARCH
        DefaultSearchProviderEnabled = true;
        DefaultSearchProviderName = "Kagi";
        DefaultSearchProviderSearchURL = "https://kagi.com/search?q={searchTerms}";
        DefaultSearchProviderSuggestURL = "https://kagi.com/api/autosuggest?q={searchTerms}";
        SearchSuggestEnabled = true;

        # SECURE DNS (DNS-over-HTTPS)
        # "automatic" upgrades to DoH when the network's resolver supports it but
        # falls back to plain DNS otherwise, so roaming onto captive-portal Wi-Fi
        # (hotels, airports) still works. Use "secure" to force DoH everywhere.
        DnsOverHttpsMode = "automatic";
        DnsOverHttpsTemplates = "https://cloudflare-dns.com/dns-query";

        # BOOKMARKS
        ManagedBookmarks = [
          { toplevel_name = "Tools"; }

          (mkFolder "Archive" [
            (mkFolder "Wayback" [
              (mkScriptlet "View" /* javascript */ ''
                window.open("https://web.archive.org/web/*/" + location.href);
              '')
              (mkScriptlet "Save" /* javascript */ ''
                window.open("https://web.archive.org/save/" + location.href);
              '')
            ])
            (mkFolder "Archive.is" [
              (mkScriptlet "View" /* javascript */ ''
                window.open("https://archive.ph/newest/" + location.href);
              '')
              (mkScriptlet "Save" /* javascript */ ''
                window.open("https://archive.ph/?run=1&url=" + encodeURIComponent(location.href));
              '')
            ])
          ])

          (mkFolder "Reverse Image" (
            let
              mkReverse =
                name: prefix:
                mkScriptlet name /* javascript */ ''
                  document.addEventListener("click", function handler(event) {
                    let image = event.target.closest("img");
                    if (!image) return;

                    event.preventDefault();
                    event.stopPropagation();
                    document.removeEventListener("click", handler, true);

                    window.open("${prefix}" + encodeURIComponent(image.src));
                  }, true);
                '';
            in
            [
              (mkReverse "Yandex" "https://yandex.com/images/search?rpt=imageview&url=")
              (mkReverse "Google Lens" "https://lens.google.com/uploadbyurl?url=")
              (mkReverse "Bing" "https://www.bing.com/images/search?view=detailv2&iss=sbi&q=imgurl:")
              (mkReverse "TinEye" "https://www.tineye.com/search?url=")
            ]
          ))

          (mkFolder "Nuke" [
            (mkScriptlet "Sticky Elements" /* javascript */ ''
              document.querySelectorAll("body *").forEach((element) => {
                let position = getComputedStyle(element).position;
                if (position === "fixed" || position === "sticky") element.parentNode.removeChild(element);
              });

              document.documentElement.style.overflow = "auto";
              document.body.style.overflow = "auto";
            '')

            (mkScriptlet "Copy Paste Restrictions" /* javascript */ ''
              ["copy", "cut", "paste", "selectstart", "contextmenu", "dragstart"].forEach((eventName) => {
                document.addEventListener(eventName, (event) => event.stopPropagation(), true);
              });

              document.querySelectorAll("*").forEach((element) => {
                element.style.userSelect = "auto";
                element.style.webkitUserSelect = "auto";
              });
            '')
          ])

          (mkFolder "Toggle" (
            let
              mkIndication = text: /* javascript */ ''
                let indication = document.body.appendChild(document.createElement("div"));
                indication.textContent = ${text};

                Object.assign(indication.style, {
                  position: "fixed",
                  top: "0",
                  left: "0",

                  zIndex: "calc(infinity)",

                  padding: "8px 16px",
                  borderRadius: "8px",

                  colorScheme: "light dark",
                  background: "Canvas",
                  color: "CanvasText",
                  font: "14px/1 system-ui",

                  pointerEvents: "none",
                });

                indication.animate(
                  [
                    { opacity: 1, offset: 0.6, easing: "cubic-bezier(0.4, 0, 0.2, 1)" },
                    { opacity: 0, offset: 1 },
                  ],
                  { duration: 1500, fill: "forwards" },
                )
                .finished
                .then(() => indication.remove());
              '';
            in
            [
              (mkScriptlet "Password Inputs" /* javascript */ ''
                let shown = false;

                document.querySelectorAll("input").forEach((input) => {
                  if (input.type === "password") {
                    input.dataset.wasPassword = "";
                    input.type = "text";
                    shown = true;
                  } else if ("wasPassword" in input.dataset) {
                    delete input.dataset.wasPassword;
                    input.type = "password";
                  }
                });

                ${mkIndication /* js */ ''"Passwords " + (shown ? "shown" : "hidden")''}
              '')

              (mkScriptlet "Design Mode" /* javascript */ ''
                document.designMode = document.designMode === "on" ? "off" : "on";

                ${mkIndication /* js */ ''"Design mode " + document.designMode''}
              '')
            ]
          ))
        ];
      };
    in
    {
      programs.firefox = {
        enable = true;

        policies = {
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          OfferToSaveLogins = false;
          PasswordManagerEnabled = false;

          ExtensionSettings = {
            "*" = {
              installation_mode = "allowed";
            };

            "uBlock0@raymondhill.net" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            };

            "{446900e4-71c2-419f-a6a7-b5ebb12e099f}" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            };

            "addon@darkreader.org" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            };

            "sponsorBlocker@ajay.app" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            };
          };

          SearchEngines = {
            Default = "Kagi";
            Add = [
              {
                Name = "Kagi";
                URLTemplate = "https://kagi.com/search?q={searchTerms}";
                SuggestURLTemplate = "https://kagi.com/api/autosuggest?q={searchTerms}";
                Method = "GET";
              }
            ];
          };
        };
      };

      environment.etc."chromium/policies/managed/helium-policies.json".source =
        json.generate "helium-policies.json" heliumPolicies;

      environment.systemPackages = [
        inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };

  flake.homeModules.browser =
    { pkgs, ... }:
    let
      json = pkgs.formats.json { };

      heliumPreferences = {
        helium.completed_onboarding = true;
        helium.services.user_consented = true;
        helium.browser.layout = 2;
        helium.browser.rounded_frame = false;
        helium.browser.new_tab_next_to_active = true;

        bookmark_bar.show_on_all_tabs = true;
        bookmark_bar.show_tab_groups = false;
        download.prompt_for_download = true;
      };
    in
    {
      xdg.config.files."helium/Default/Preferences".source =
        json.generate "helium-preferences.json" heliumPreferences;

      xdg.mime-apps.default-applications = {
        "text/html" = "helium.desktop";
        "x-scheme-handler/http" = "helium.desktop";
        "x-scheme-handler/https" = "helium.desktop";
        "x-scheme-handler/about" = "helium.desktop";
        "x-scheme-handler/unknown" = "helium.desktop";
      };
    };
}
