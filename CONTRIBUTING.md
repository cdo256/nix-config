# Contributing to mutix

This repository contains Christina's NixOS and Home Manager configurations using the Nix flake system.

## Repository Structure

### Core Directories

- **`modules/`** - Reusable NixOS and Home Manager modules
  - `modules/home/` - Home Manager modules (user-level configs)
  - `modules/nixos/` - NixOS system modules (system-level configs)

- **`systems/`** - Machine-specific configurations
  - Each subdirectory represents a specific machine (e.g., `peter/`, `halley/`, `makeda/`)
  - Contains both NixOS and Home Manager configs for that system

- **`users/`** - User-specific configurations
  - `users/cdo/` - Christina's user configuration
  - `users/example/` - Example user template

- **`packages/`** - Custom package definitions
  - `packages/python-utils/` - Custom Python utilities
  - Individual `.nix` files for other packages

- **`manifests/`** - Package collections organized by purpose
  - `base.nix`, `desktop.nix`, `development.nix`, `games.nix`, etc.
  - Groups related packages for easy inclusion

- **`lib/`** - Helper functions and utilities
  - `mkHomeConfiguration.nix`, `mkNixosSystem.nix` - Configuration builders
  - Various utility functions for the flake

- **`files/`** - Static configuration files and assets
  - SSH keys, wallpapers, application configs

### Root Files

- **`flake.nix`** - Main flake definition and outputs
- **`devices.nix`** - Device-specific settings and SSH keys
- **`overlays.nix`** - Package overlays and modifications
- **`outputs.nix`** - Flake output definitions
- **`justfile`** - Task runner commands for common operations

### Build Artifacts

- `result*` directories - Symlinks to Nix store builds (ignored in git)

## Architecture

The repository follows a modular design:

1. **Modules** provide reusable functionality
2. **Systems** compose modules for specific machines
3. **Users** define user-specific Home Manager configurations
4. **Manifests** group packages by purpose
5. **Lib functions** provide utilities for building configurations

# Agent Guidelines for Git Commit Messages

## Format

```
<directory>: <subdirectory>: <action description>
```

## Directory Mapping

Commit prefixes map directly to repository structure:

- `home:` → `modules/home/`
- `nixos:` → `modules/nixos/`
- `systems:` → `systems/`
- `packages:` → `packages/`
- `manifests:` → `manifests/`
- `users:` → `users/`
- `lib:` → `lib/`
- `overlays:` → `overlays/`
- `files:` → `files/`
- `flake:` → root flake files
- `devices:` → `devices.nix`

## Examples

- `modules/home/git.nix` → `home: git: Set credential helper.`
- `packages/python-utils/` → `packages: python-utils: Add git-credentials-read.`
- `systems/peter/` → `systems: peter: Add sway monitor layout.`
- `modules/nixos/nix.nix` → `nixos: nix: Add github token file.`
- `manifests/desktop/` → `manifests: desktop: Add teams.`

## Rules

1. Use imperative mood: "Add", "Fix", "Update", "Remove"
2. Match the two-level structure: `<scope>: <module>: <action>.`
3. For multi-file changes, use the most significant component
4. Use `wip` for incomplete work
5. Use `flake: Update inputs` for dependency updates

## Multi-directory Changes

When changes span multiple directories, choose the most significant or use the broader scope without the second level (e.g., just `nixos: Fix warnings`).
ixos: Fix warnings.`).
