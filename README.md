# nixcfgs

[![Built with Nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org)
![License](https://img.shields.io/github/license/fdnt7/nixcfgs)

My NixOS configurations.

This repository consolidates my previous per-host configuration files 
([`cuties-only`](https://github.com/fdnt7/nix-config) and 
[`autism-inside`](https://github.com/fdnt7/autism-inside)) into a single 
monorepo. Over time, it will also include the NixOS configurations for all of 
my other hosts.

> [!WARNING]
> Migration of [`cuties-only`](https://github.com/fdnt7/nix-config) has ceased
> as I no longer have access to the hardware. The setup is functional but still 
> missing some features. In the meantime, 
> [`autism-inside`](https://github.com/fdnt7/autism-inside) and other hosts 
> (e.g. `estrogen-fuelled`) have not yet begun migration.

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
- Customisable global constants passed down to [`flake.nix`](./flake.nix) and
  reused in both NixOS and Home Manager configurations.
- Hopefully a best practice compliant configuration structure with idiomatic nix
  usage as a language.

## Prerequisites

Before installation, these directories and files must be present:

- `/persist/etc/nixcfgs` - the flake directory
- `/persist/usr/share/fonts/seguiemj.ttf` - Windows 11's Segoe UI Emoji font
- `/persist/var/lib/sops-nix/key.txt` - the key file for sops

Optionally, edit the attributes of `nixcfgs` in `flake.nix` as seen fit.

## Attributions

- [@Misterio77](https://github.com/Misterio77)’s 
[starter config template](https://github.com/Misterio77/nix-starter-configs) 
(standard version) and 
[personal configurations](https://github.com/Misterio77/nix-config/), which 
heavily inspired the structure of my own configuration.
- [@NotAShelf](https://github.com/notashelf)'s guide on 
[Full Disk Encryption and Impermanence on NixOS](https://notashelf.dev/posts/impermanence).

