# NixOS Configurations

This repository contains my personal NixOS configurations for multiple machines.

> ⚠️ This is **neither a beginner-friendly nor a generalised setup**.
> It contains my specific usecases with my specific set of machines only, and it may also contain bugs, hacks, and otherwise incomplete codes.
> Any harm or damages caused by using this configurations I do not seek any responsibilities.

---

## Repository Structure

```
.
├─── flake.nix
├─┬─ hosts/               # Machine-specific system configurations
│ ├─ hosts/minibook         # Chuwi Minibook X (2023)
│ ├─ hosts/n5               # Minisforum N5 Air NAS
│ ├─ hosts/ser8             # Beelink ser8 8745HS
│ ├─ hosts/wsl              # Windows Subsystem for Linux
│ └─ hosts/x1c13            # Lenovo ThinkPad X1 Carbon Gen. 13
├── modules/              # Reusable NixOS configuration modules
├── overlays/             # Overlays for more up-to-date packages and patches
├── modules/              # Reusable NixOS / HM modules
├── pkgs/                 # Packages unavailable on mainline nixpkgs
├── secrets/              # Encrypted secrets (SOPS)
└── users/
```

## Flake outputs

### `nixosConfigurations`
Renders NixOS system configurations for each hosts(`minibook`, `n5`, etc...) that are used for `nixos-rebuild`. The list of hosts are available in `hosts/default.nix`. 

### `nixosModules`
A set of NixOS modules that resided in `modules/`. Not intended to be used externally. The list of modules are available in `modules/default.nix`.

### `apps`
Set of shell scripts that can be run with `nix run` command. See `flake.nix` for the specifics.
> ⚠️ Only intended to be run from within the directory of the repository. Some are tailored to only be used for my current configurations.

### `overlays`
#### General overlays
  - `additions`\
     Exposes packages from `pkgs/` into system configuration `pkgs`.
  - `unstable-packages`\
     Exposes [`nixos-unstable`](https://github.com/NixOS/nixpkgs/tree/nixos-unstable) from the flake input into system configuration under `pkgs.unstable`.
  - `nixpkgs-patched`\
     Adds `nixos-unstable` packages with additional patches applied, if there are patches specified, into system configuration under `pkgs.patched`.
    
#### Package specific overlays
  - `ghostty-flake`\
     Adds `ghostty` package from [ghostty-org/ghostty](https://github.com/ghostty-org/ghostty) Nix flake into system configuration `pkgs`.
  - `ghostty-patched`\
     Overrides `ghostty` package with additional patches, if there are patches specified.
  - `gnomeExtensions-addon`\
     Adds/overrides packages under `pkgs.gnomeExtensions`. Currently packaged extensions are as belows.
    - [axelitama/power-off-options](https://github.com/axelitama/power-off-options) latest built from source.
    - [flexagoon/rounded-window-corners](https://github.com/flexagoon/rounded-window-corners) latest from [extensions.gnome.org](https://extensions.gnome.org/extension/7048/rounded-window-corners-reborn/).
  - `goofcord-latest`\
     [Milkshiift/GoofCord](https://github.com/Milkshiift/GoofCord) latest with couple of patches.
    - The latest version of Electron requiring `desktopName` value in `package.json`. See NixOS/nixpkgs#505078.
    - Changes the `icon` of `.desktop` file into `discord`. (Requires `discord` package to be installed.) 
  - `deno-latest`\
     [denoland/deno](https://github.com/denoland/deno) latest.
  - `libhangul-latest`\
     [libhangul/libhangul](https://github.com/libhangul/libhangul) latest with a small patch applied to change default behavior to not combine first consonants into doubles.
  - `ibus-hangul-latest`\
     [libhangul/ibus-hangul](https://github.com/libhangul/ibus-hangul) latest.
   
### `packages`
  - `birdtray`: [gyunaev/birdtray](https://github.com/gyunaev/birdtray)
  - `deno-bin`: [denoland/deno](https://github.com/denoland/deno) latest precompiled binary with `autoPatchelfHook`.
  - `gulim`: [googlefonts/gulim](https://github.com/googlefonts/gulim)
  - `batang`: [googlefonts/batang](https://github.com/googlefonts/batang)
  - `hop`: [golbin/hop](https://github.com/golbin/hop)
