{
  nixConfig = {
    extra-experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];

    builders-use-substitutes = true;
    http-connections = 50;
    show-trace = true;
    trusted-users = [
      "root"
      "@admin"
    ];
    use-xdg-base-directories = true;
    warn-dirty = false;
  };

  inputs.nixpkgs = {
    url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  inputs.nix-darwin = {
    url = "github:nix-darwin/nix-darwin";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.determinate = {
    url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };

  inputs.hjem = {
    url = "github:feel-co/hjem";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.flake-parts = {
    url = "github:hercules-ci/flake-parts";
    inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  inputs.homebrew = {
    url = "github:zhaofengli/nix-homebrew";
  };
  inputs.homebrew-core = {
    url = "github:homebrew/homebrew-core";
    flake = false;
  };
  inputs.homebrew-cask = {
    url = "github:homebrew/homebrew-cask";
    flake = false;
  };
  inputs.homebrew-anomalyco = {
    url = "github:anomalyco/homebrew-tap";
    flake = false;
  };

  inputs.helix = {
    url = "github:helix-editor/helix";
  };

  inputs.ublock = {
    url = "github:imputnet/uBlock";
    flake = false;
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs.lib.attrsets) filterAttrs mapAttrs' nameValuePair;
      inherit (inputs.nixpkgs.lib.filesystem) readDir;
      inherit (inputs.nixpkgs.lib.strings) hasSuffix removeSuffix;

      readCoal =
        directory:
        readDir directory
        |> filterAttrs (name: _: hasSuffix ".nix" name)
        |> mapAttrs' (name: _: nameValuePair (removeSuffix ".nix" name) "${directory}/${name}");
    in
    (import "${inputs.flake-parts}/lib.nix" {
      lib = import ./lib inputs.nixpkgs.lib;

      builtinModules = readCoal "${inputs.flake-parts}/modules";
      extraModules = readCoal "${inputs.flake-parts}/extras";
    }).mkFlake
      { inherit inputs; }
      (
        { lib, ... }:
        let
          inherit (lib.filesystem) listFilesRecursive;
          inherit (lib.lists) filter;
          inherit (lib.strings) hasSuffix;
        in
        {
          systems = [ "aarch64-darwin" ];

          imports = filter (hasSuffix ".mod.nix") (listFilesRecursive ./.);
        }
      );
}
