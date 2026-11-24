#!/usr/bin/env bash
set -e

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

URL="https://opencode.ai/update/api/latest/cli/opencode/opencode-linux-x64-baseline.tar.gz"
DIR="$HOME/.local/opt"

curl -fL "$URL" -o "$TMP/opencode.tar.gz"
tar -xzf "$TMP/opencode.tar.gz" -C "$DIR"

echo "Installed: $DIR/opencode"
opencode --version
