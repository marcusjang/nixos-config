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
│ ├─ hosts/nas400           # ipTIME NAS400 (disused)
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

### Flake outputs

* TODO: Describe flake outputs

---

## Usage

Build/switch a host (requires `nix-command` experimental feature):

```bash
nix run .#update (switch|boot|dry-activate|...)
```

* TODO: Describe `nix run` commands
