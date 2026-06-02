{ pkgs }:
# Semi-official zed-wakatime-ls language server (lets the Zed WakaTime extension
# run without nix-ld). Rather than copy-pasting the package definition locally --
# which would silently drift if upstream changes -- we fetch the single,
# self-contained package.nix straight from the open nixpkgs PR (pinned to a
# commit) and callPackage it with our own pkgs.
#
# To follow new pushes to the PR: bump `rev`, then update `hash` to the value
# Nix reports on the resulting build mismatch.
#
# Once the PR merges, delete this file and its pkgs/default.nix entry; the same
# `pkgs.zed-wakatime-ls` attribute will then resolve from nixpkgs.
# Refs: https://github.com/NixOS/nixpkgs/pull/512098
let
  rev = "9ab55a5e38f55b2b2f539139c10d81801b8d3e4a";
  package = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/krishnans2006/nixpkgs/${rev}/pkgs/by-name/ze/zed-wakatime-ls/package.nix";
    hash = "sha256-fhDjTvJG4K9UqTqBMIxGiYTB1wc67fG2EVY6D5XxgTA=";
  };
in
pkgs.callPackage package { }
