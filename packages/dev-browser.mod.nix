{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      inherit (lib.licenses) mit;
      inherit (lib.platforms) linux;
    in
    {
      # DEV BROWSER
      # Browser automation CLI: a Rust front-end (cli/) that embeds a Node daemon
      # bundle (daemon/) driving Playwright + Chromium inside a QuickJS sandbox.
      #
      # Upstream ships as an npm launcher that downloads a prebuilt release binary
      # and, on first run, `npm install`s the daemon deps and `playwright install`s
      # Chromium into ~/.dev-browser. We instead build all three parts from source
      # and set DEV_BROWSER_DAEMON so the CLI uses a fully nix-provided daemon
      # (requires_runtime_install = false), skipping every network install step.
      #
      # The daemon reaches into playwright-core's private server/client internals,
      # so its playwright version must match the one whose Chromium revision nixpkgs
      # ships. nixpkgs' playwright-driver is playwright-core 1.59.1 (chromium-1217);
      # the only value-level `playwright` import the daemon makes is `chromium`,
      # which playwright-core re-exports, so it backs both `playwright` and
      # `playwright-core` here even though upstream pins 1.58.2.
      packages.dev-browser = pkgs.callPackage (
        {
          stdenvNoCC,
          rustPlatform,
          fetchFromGitHub,
          buildNpmPackage,
          makeWrapper,
          nodejs,
          esbuild,
          playwright-driver,
        }:
        let
          version = "0.2.8";

          src = fetchFromGitHub {
            owner = "SawyerHood";
            repo = "dev-browser";
            tag = "v${version}";
            hash = "sha256-QDrc5Q10eVZsgORNaM8qGh1jl/S5/AmcnY9xRQZ3XgA=";
          };

          # Pure-JS daemon deps (quickjs-emscripten + its @jitl wasm variants, and
          # zod for the daemon bundle). Playwright is provided separately from
          # nixpkgs so its Chromium revision matches.
          nodeDeps = buildNpmPackage {
            pname = "dev-browser-node-deps";
            inherit version;
            src = ./dev-browser;
            npmDepsHash = "sha256-6bokn5sSIf0vUJt1qyyCzQju458CPp69AkbwFl2N1kI=";
            dontNpmBuild = true;
            installPhase = ''
              runHook preInstall
              mkdir -p "$out"
              cp -r node_modules "$out/node_modules"
              runHook postInstall
            '';
          };

          # esbuild the two daemon artifacts the Rust crate embeds via include_str!.
          daemonDist = stdenvNoCC.mkDerivation {
            pname = "dev-browser-daemon-dist";
            inherit version src;

            nativeBuildInputs = [
              nodejs
              esbuild
            ];

            buildPhase = ''
              runHook preBuild

              cd daemon
              ln -s ${nodeDeps}/node_modules node_modules

              # Launch the nix-provided Chromium instead of a Playwright-managed
              # download. The daemon exposes no executablePath option, so thread
              # one through from the environment at the single launch site.
              substituteInPlace src/browser-manager.ts \
                --replace-fail \
                  "viewport: headless ? undefined : null," \
                  "viewport: headless ? undefined : null, ...(process.env.DEV_BROWSER_CHROMIUM ? { executablePath: process.env.DEV_BROWSER_CHROMIUM } : {}),"

              esbuild src/daemon.ts --bundle --platform=node --format=esm \
                --outfile=dist/daemon.bundle.mjs \
                --external:playwright --external:quickjs-emscripten --external:@jitl/*

              esbuild src/sandbox/forked-client/bundle-entry.ts --bundle --format=iife \
                --global-name=__PlaywrightClient --outfile=dist/sandbox-client.js \
                --platform=neutral --target=es2022

              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall
              mkdir -p "$out"
              cp dist/daemon.bundle.mjs "$out/daemon.mjs"
              cp dist/sandbox-client.js "$out/sandbox-client.js"
              runHook postInstall
            '';
          };
        in
        rustPlatform.buildRustPackage {
          pname = "dev-browser";
          inherit version src;

          sourceRoot = "${src.name}/cli";

          cargoHash = "sha256-zGXmiDzFUd/2H4qpGzb1SrghXK/D6/7KOR2nUWwznmE=";

          nativeBuildInputs = [ makeWrapper ];

          # cli/src/daemon.rs include_str!s ../../daemon/dist/*, i.e. source/daemon/dist.
          postPatch = ''
            chmod -R u+w ../daemon
            mkdir -p ../daemon/dist
            cp ${daemonDist}/daemon.mjs ../daemon/dist/daemon.bundle.mjs
            cp ${daemonDist}/sandbox-client.js ../daemon/dist/sandbox-client.js
          '';

          # Assemble a self-contained daemon runtime dir next to the binary and
          # point the CLI at it, so it never extracts to or installs into ~/.
          postInstall = ''
            runtime="$out/libexec/dev-browser"
            mkdir -p "$runtime/node_modules"

            cp ${daemonDist}/daemon.mjs "$runtime/daemon.mjs"
            cp ${daemonDist}/sandbox-client.js "$runtime/sandbox-client.js"

            for dep in ${nodeDeps}/node_modules/*; do
              name="$(basename "$dep")"
              case "$name" in
                .*) continue ;;
              esac
              ln -s "$dep" "$runtime/node_modules/$name"
            done

            # The daemon imports `chromium` from "playwright"; the npm
            # playwright-core (matching the vendored client fork) re-exports it.
            ln -s ${nodeDeps}/node_modules/playwright-core "$runtime/node_modules/playwright"

            chrome=$(echo ${playwright-driver.browsers}/chromium-[0-9]*/chrome-linux64/chrome)

            wrapProgram "$out/bin/dev-browser" \
              --prefix PATH : ${lib.makeBinPath [ nodejs ]} \
              --set DEV_BROWSER_DAEMON "$runtime/daemon.mjs" \
              --set DEV_BROWSER_CHROMIUM "$chrome" \
              --set PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers} \
              --set PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS true
          '';

          passthru.skill = "${src}/skills/dev-browser";

          meta = {
            description = "Control browsers with sandboxed JavaScript scripts";
            homepage = "https://github.com/SawyerHood/dev-browser";
            license = mit;
            mainProgram = "dev-browser";
            platforms = linux;
          };
        }
      ) { };
    };
}
