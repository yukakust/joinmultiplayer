#!/usr/bin/env bash
# C2 anti-drift guard: the canonical connector is aiconic-brain/joinmultiplayer/join.py (served live by the relay
# as /mp/join.py). This package bundles a SNAPSHOT of it as src/joinmultiplayer/connector.py. Run this before every
# release to re-sync, and it FAILS if they differ (so you never publish a stale wheel). Bump the version, then build.
set -e
SRC="${1:-$HOME/Desktop/LLM/aiconic-brain/joinmultiplayer/join.py}"
DST="$(dirname "$0")/src/joinmultiplayer/connector.py"
[ -f "$SRC" ] || { echo "✗ canonical connector not found: $SRC"; exit 1; }
if diff -q "$SRC" "$DST" >/dev/null 2>&1; then
  echo "✓ in sync — connector.py == $SRC"
else
  echo "→ drift detected; re-syncing connector.py from $SRC"
  cp "$SRC" "$DST"
  echo "✓ synced. Now bump version in pyproject.toml + __init__.py, then: rm -rf dist && python3 -m build && ./upload.sh"
fi
