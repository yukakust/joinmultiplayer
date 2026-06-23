#!/usr/bin/env bash
# Defensively reserve PyPI name VARIANTS as redirect packages (each just depends on the real
# `joinmultiplayer` and re-exports its CLI, so `uvx joinmultiplayer-ai` also works + can't be typosquatted).
# Run this AFTER `joinmultiplayer` itself is published. Needs your PyPI token configured for twine
# (e.g. ~/.pypirc or TWINE_USERNAME=__token__ TWINE_PASSWORD=pypi-...).
set -e
VARIANTS=("joinmultiplayer-ai" "join-multiplayer" "join-multiplayer-ai" "multiplayer-join" "multiplayer-ai")
VERSION="0.1.0"
WORK="$(mktemp -d)"
for name in "${VARIANTS[@]}"; do
  mod="$(echo "$name" | tr '-' '_')"
  d="$WORK/$name"; mkdir -p "$d/src/$mod"
  cat > "$d/pyproject.toml" <<EOF
[build-system]
requires = ["setuptools>=61"]
build-backend = "setuptools.build_meta"

[project]
name = "$name"
version = "$VERSION"
description = "Reserved alias — install the 'joinmultiplayer' package instead. https://joinmultiplayer.ai"
readme = "README.md"
license = { text = "MIT" }
requires-python = ">=3.9"
dependencies = ["joinmultiplayer"]

[project.urls]
Homepage = "https://joinmultiplayer.ai"

[project.scripts]
$name = "$mod:main"

[tool.setuptools.packages.find]
where = ["src"]
EOF
  cat > "$d/src/$mod/__init__.py" <<EOF
"""Reserved alias for the 'joinmultiplayer' package. See https://joinmultiplayer.ai"""
from joinmultiplayer.connector import main
__all__ = ["main"]
EOF
  echo "Reserved alias — use \`uvx joinmultiplayer\`. https://joinmultiplayer.ai" > "$d/README.md"
  ( cd "$d" && python3 -m build >/dev/null 2>&1 ) && echo "  built  $name"
  twine upload "$d"/dist/* && echo "  ✅ uploaded $name"
done
echo "Done — variants reserved (each redirects to joinmultiplayer)."
