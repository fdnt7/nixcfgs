# nixcfgs

[![Built with Nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org)
![License](https://img.shields.io/github/license/fdnt7/nixcfgs)

My NixOS configurations.

This repository holds the NixOS configurations for my hosts in a single
monorepo. Currently that is `fw16`; the earlier `cuties-only` and
`lavender-pilled` hosts are retired and remain in the git history.

## Structure

- [`hosts/common/global`](./hosts/common/global) - configuration shared by every
  host
- [`hosts/common/optional`](./hosts/common/optional) - opt-in features, one per
  file, imported by the hosts that want them
- [`hosts/common/users`](./hosts/common/users) - user accounts
- `hosts/<name>` - a host: its hardware, its list of imports, and whatever is
  specific to it
- [`modules`](./modules) - reusable NixOS and Home Manager modules exported by
  the flake

State that must survive a reboot is declared next to the feature that creates
it, through `environment.persistence`.

## Features

- Extensive utilisation of [Nix flakes](https://nixos.wiki/wiki/Flakes)
- Modular home configuration file management with
  [`home-manager`](https://github.com/nix-community/home-manager)
- Full single [`Btrfs`](https://docs.kernel.org/filesystems/btrfs.html)
  partition disk encryption using
  [`cryptsetup`](https://gitlab.com/cryptsetup/cryptsetup)
- Opt-in root persistence with
  [`impermanence`](https://github.com/nix-community/impermanence) where the root
  subvolume is cleared on every boot
- Declarative encrypted secrets management with
  [`sops-nix`](https://github.com/Mic92/sops-nix)
- Hopefully a best practice compliant configuration structure with idiomatic nix
  usage as a language.

## Prerequisites

Before installation, this file must be present:

- `/persist/secrets/<user>.passwd` - the user's password hash, from
  `mkpasswd -m yescrypt`

## Attributions

- [@Misterio77](https://github.com/Misterio77)'s
  [starter config template](https://github.com/Misterio77/nix-starter-configs)
  (standard version) and
  [personal configurations](https://github.com/Misterio77/nix-config/), which
  heavily inspired the structure of my own configuration.
- [@NotAShelf](https://github.com/notashelf)'s guide on
  [Full Disk Encryption and Impermanence on NixOS](https://notashelf.dev/posts/impermanence).
