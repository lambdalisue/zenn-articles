# Zenn authoring helpers. Run inside the Nix devShell (direnv loads it
# automatically; otherwise use `nix develop`).

# List available recipes.
default:
    @just --list

# Start the local preview server (http://localhost:8000).
preview: _deps
    npx zenn preview

# Scaffold a new article under articles/.
new-article: _deps
    npx zenn new:article

# Scaffold a new book under books/.
new-book: _deps
    npx zenn new:book

# Install the locked dependencies, but only when they are missing: `npx zenn`
# turns interactive and stalls if zenn-cli is not already in node_modules.
[private]
_deps:
    #!/usr/bin/env bash
    set -euo pipefail
    [ -d node_modules ] || npm ci
