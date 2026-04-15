#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_DIR="$ROOT_DIR/.tools"
DOWNLOADS_DIR="$ROOT_DIR/.downloads"
ARCH="$(uname -m)"

case "$ARCH" in
  arm64) ADOPTIUM_ARCH="aarch64" ;;
  x86_64) ADOPTIUM_ARCH="x64" ;;
  *)
    echo "Unsupported macOS architecture: $ARCH" >&2
    exit 1
    ;;
esac

mkdir -p "$TOOLS_DIR" "$DOWNLOADS_DIR"

JDK_TARBALL="$DOWNLOADS_DIR/temurin-21-macos-${ADOPTIUM_ARCH}.tar.gz"
JDK_LINK="$TOOLS_DIR/jdk-current"

if [ ! -f "$JDK_TARBALL" ]; then
  echo "Downloading Temurin 21 JDK for macOS ${ADOPTIUM_ARCH}..."
  curl -fsSL -o "$JDK_TARBALL" \
    "https://api.adoptium.net/v3/binary/latest/21/ga/mac/${ADOPTIUM_ARCH}/jdk/hotspot/normal/eclipse"
fi

echo "Extracting local JDK..."
rm -rf "$TOOLS_DIR"/jdk-21* "$JDK_LINK"
tar -xzf "$JDK_TARBALL" -C "$TOOLS_DIR"

JDK_DIR="$(find "$TOOLS_DIR" -maxdepth 1 -type d -name 'jdk-21*' | head -n 1)"
if [ -z "$JDK_DIR" ]; then
  echo "Could not locate extracted JDK directory." >&2
  exit 1
fi

ln -s "$JDK_DIR" "$JDK_LINK"
echo "Local Java is ready at $JDK_LINK/Contents/Home"
