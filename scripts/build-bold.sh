#!/usr/bin/env bash
# Builds the bridge against the `bold` branch of the typescript-utcp fork, which holds
# fixes not yet released upstream. Expects (or creates) ../typescript-utcp next to this repo.
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
utcp="$(dirname "$here")/typescript-utcp"

if [ ! -d "$utcp/.git" ]; then
  git clone --branch bold https://github.com/Eli-Golin/typescript-utcp.git "$utcp"
fi
git -C "$utcp" fetch --quiet origin bold
git -C "$utcp" checkout --quiet bold
git -C "$utcp" merge --quiet --ff-only origin/bold

(cd "$utcp" && bun install --frozen-lockfile && bun run build)
(cd "$here" && npm install && npm run build)
echo "Built $here/dist/index.js"
