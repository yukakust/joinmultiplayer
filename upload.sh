#!/usr/bin/env bash
# One-shot PyPI publish for joinmultiplayer. You paste your PyPI API token ONCE (hidden input);
# it publishes the package, then offers to reserve the 5 alias names too. Token is never written to disk.
set -e
cd "$(dirname "$0")"

echo "Need a PyPI API token first (one time):"
echo "  1) account:  https://pypi.org/account/register/   (or log in)"
echo "  2) token:    https://pypi.org/manage/account/token/  → Add API token"
echo "               → Scope: 'Entire account (all projects)'  ← required for a NEW project"
echo "               → Create → copy the whole 'pypi-...' string"
echo
read -rsp "Paste your PyPI API token (pypi-...): " TOK; echo
[ -z "$TOK" ] && { echo "no token — aborting."; exit 1; }
export TWINE_USERNAME=__token__
export TWINE_PASSWORD="$TOK"

echo "→ publishing joinmultiplayer 0.1.0 ..."
python3 -m twine upload dist/*
echo "✅ joinmultiplayer is on PyPI. Verify with:  uvx joinmultiplayer --onboard"
echo

read -rp "Also reserve the 5 alias names (joinmultiplayer-ai, join-multiplayer, …)? [y/N] " yn
if [[ "$yn" == [yY]* ]]; then
  ./reserve_variants.sh
else
  echo "skipped variants — you can run ./reserve_variants.sh later (same token)."
fi
