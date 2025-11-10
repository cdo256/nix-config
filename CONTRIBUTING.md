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

# Development Guide

## Module System Architecture

This flake uses a two-tier module system:

### NixOS Modules (`modules/nixos/`)
- System-level configurations
- Imported in `systems/*/default.nix` under `modules.nixos`
- Have access to system-wide options and services
- Can define users, system services, kernel modules, etc.

### Home Manager Modules (`modules/home/`)
- User-level configurations
- Imported in `users/*/default.nix` or system-specific home configurations
- Only have access to user-space options
- Configure user applications, dotfiles, user services

## External Input Integration

### Flake Inputs with Modules
Many flake inputs provide both NixOS and Home Manager modules that must be imported separately:

#### sops-nix (Secrets Management)
- **NixOS Module**: `inputs.sops-nix.nixosModules.sops`
  - Import in: `systems/*/default.nix` → `modules.nixos`
  - Provides: System-level secret management, `/etc/sops/age/keys.txt`
  - Options: `sops.secrets.*` with `owner`, `group`, `mode`
- **Home Manager Module**: `inputs.sops-nix.homeManagerModules.sops`
  - Import in: `users/*/default.nix` → base modules
  - Provides: User-level secret management
  - Options: `sops.secrets.*` with `mode` only (no `owner`/`group`)
  - Requires: `sops.age.keyFile` configuration

#### plasma-manager
- **Home Manager Module**: `inputs.plasma-manager.homeManagerModules.plasma-manager`
- Note: `homeManagerModules` has been renamed to `homeModules`

#### stylix (System Theming)
- **NixOS Module**: `inputs.stylix.nixosModules.stylix`
- **Home Manager Module**: `inputs.stylix.homeManagerModules.stylix`

### Module Import Locations

#### For NixOS Modules
Add to `systems/*/default.nix`:
```nix
modules.nixos = [
  # ... other modules
  inputs.some-input.nixosModules.default
  # ...
];
```

#### For Home Manager Modules
Add to `users/*/default.nix` in `baseModules`:
```nix
baseModules = [
  # ... other modules
  inputs.some-input.homeManagerModules.default
  # ...
];
```

## Common Development Tasks

### Testing Changes

My preference is to reduce the output verbosity using `--no-nom --quiet`.

```bash
# Dry run (check for errors without building)
nh os build --no-nom --quiet

# Build and switch (for NixOS systems)
nh os switch --no-nom --quiet

# Build home-manager only
nh home switch --no-nom --quiet

# Build specific system
nh os build -H HOST --no-nom --quiet
```

### Adding New Secrets
1. Create/edit secret file: `sops secrets/secrets.yaml`
2. Add secret to NixOS module: `modules/nixos/*/secrets.nix`
3. Add secret to home module that needs it
4. For home modules, ensure sops is configured:
   ```nix
   sops.secrets.my-secret = {
     sopsFile = "${inputs.cdo-secrets}/my-secret.sops";
     format = "binary";
     mode = "0400";
     # Note: no owner/group for home-manager sops
   };
   ```

### Adding New Modules
1. Create module file in appropriate directory
2. Add module to import list:
   - NixOS: `systems/*/default.nix` → `modules.nixos`
   - Home: `users/*/default.nix` → `baseModules` or conditional blocks

## Troubleshooting Common Issues

### sops-nix Issues

**Error: `The option 'home-manager.users.*.sops' does not exist`**
- **Cause**: Missing `inputs.sops-nix.homeManagerModules.sops` import
- **Fix**: Add to user's base modules in `users/*/default.nix`

**Error: `The option '*.sops.secrets.*.group' does not exist`**
- **Cause**: Using NixOS sops options in home-manager
- **Fix**: Remove `owner` and `group` from home-manager sops secrets

**Error: `No key source configured for sops`**
- **Cause**: Missing sops configuration in home-manager
- **Fix**: Create `modules/home/sops.nix` with `sops.age.keyFile` setting

### Module Import Issues

**Error: `The option '*.someOption' does not exist`**
- **Cause**: Missing module import for the input providing that option
- **Fix**: Check if the required input's module is imported in the right place

**Error: Infinite recursion or dependency cycles**
- **Cause**: Circular dependencies between modules
- **Fix**: Review module imports and move shared configuration to a common module

### Build Issues

**Error: `attribute 'xyz' missing`**
- **Cause**: Flake input not passed to module or typo in input name
- **Fix**: Check `extraSpecialArgs` in `modules/nixos/hm.nix` and input definitions

## Debugging Commands

```bash
# Show detailed error trace
nixos-rebuild switch --flake . --show-trace

# Evaluate specific option
nix eval .#nixosConfigurations.halley.config.some.option

# Check what's in the flake outputs
nix flake show

# Update flake inputs
nix flake update

# Check specific input version
nix flake metadata

# Garbage collect old builds
nix-collect-garbage -d
```

## Architecture Decisions

### Why Two-Tier Modules?
- **Separation of Concerns**: System vs user configuration
- **Reusability**: Modules can be mixed and matched per machine
- **Flexibility**: Different users can have different home configurations

### Why Manifests?
- **Grouping**: Logical package collections (desktop, development, etc.)
- **Flexibility**: Easy to enable/disable entire feature sets
- **Maintainability**: Centralized package management

### Secrets Strategy
- **sops-nix**: Encrypted secrets in git, decrypted at runtime
- **Age encryption**: SSH key-based, simpler than GPG
- **Separation**: System secrets (NixOS) vs user secrets (Home Manager)
