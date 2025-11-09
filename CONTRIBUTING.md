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
