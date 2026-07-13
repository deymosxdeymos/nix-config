{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      inherit (lib.licenses) mit;
      inherit (lib.platforms) linux;
      inherit (lib.strings) makeSearchPath;
    in
    {
      # OPEN COMPUTER USE (Linux runtime)
      # The npm distribution is only a Node launcher that shells out to a
      # per-platform native runtime. On Linux that runtime is a self-contained
      # Go binary (apps/OpenComputerUseLinux) that embeds a Python AT-SPI2 script
      # and speaks the stdio MCP protocol. We build that binary directly and wrap
      # it with a PyGObject environment plus the GObject-Introspection typelibs it
      # dlopens at runtime (Atspi for the accessibility tree, Gdk for screenshots
      # and keysyms).
      packages.open-computer-use = pkgs.callPackage (
        {
          buildGoModule,
          fetchFromGitHub,
          makeWrapper,
          python3,
          glib,
          gobject-introspection,
          at-spi2-core,
          atk,
          gtk3,
          gdk-pixbuf,
          pango,
          harfbuzz,
          cairo,
        }:
        let
          pythonEnv = python3.withPackages (ps: [ ps.pygobject3 ]);

          typelibPath = makeSearchPath "lib/girepository-1.0" [
            glib.out
            gobject-introspection
            at-spi2-core
            atk
            gtk3
            gdk-pixbuf
            pango
            harfbuzz
            cairo
          ];
        in
        buildGoModule (finalAttrs: {
          pname = "open-computer-use";
          version = "0.2.0";

          src = fetchFromGitHub {
            owner = "iFurySt";
            repo = "open-codex-computer-use";
            tag = "v${finalAttrs.version}";
            hash = "sha256-w1/XL4X+AG+UH7W5R3V2vnLAp4a7ZU0/Ry01RVCVrUY=";
          };

          modRoot = "apps/OpenComputerUseLinux";

          # Pure-stdlib Go program with no module dependencies (no go.sum).
          vendorHash = null;

          # The upstream build script disables cgo; the code only touches the
          # standard library and syscall, so no C toolchain is required.
          env.CGO_ENABLED = "0";

          ldflags = [
            "-s"
            "-w"
            "-X main.version=${finalAttrs.version}"
          ];

          nativeBuildInputs = [ makeWrapper ];

          # `go build` names the binary after the module directory; normalise it
          # to the CLI name the launcher, skill, and MCP configs expect, then wrap
          # it so the embedded runtime.py finds python3 and its typelibs.
          postInstall = /* bash */ ''
            mv "$out/bin/opencomputeruselinux" "$out/bin/open-computer-use"

            wrapProgram "$out/bin/open-computer-use" \
              --prefix PATH : ${lib.makeBinPath [ pythonEnv ]} \
              --prefix GI_TYPELIB_PATH : ${typelibPath}

            ln -s open-computer-use "$out/bin/ocu"
          '';

          # The upstream skill drives the CLI (`ocu call <tool>`) and is the
          # idiomatic way to expose Computer Use to agents that lack native MCP,
          # such as pi. Surface it from the pinned source as a single source of
          # truth rather than vendoring a copy into this repo.
          passthru.skill = "${finalAttrs.src}/skills/open-computer-use";

          meta = {
            description = "Open-source cross-platform Computer Use MCP server (Linux runtime)";
            homepage = "https://github.com/iFurySt/open-codex-computer-use";
            license = mit;
            mainProgram = "open-computer-use";
            platforms = linux;
          };
        })
      ) { };
    };
}
