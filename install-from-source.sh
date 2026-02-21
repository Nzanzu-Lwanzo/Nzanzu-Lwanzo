#!/usr/bin/env bash

###############################################################################
# install-from-source.sh
#
# PURPOSE:
#   Install software from source into your home directory WITHOUT sudo.
#
# HOW IT WORKS:
#   1. Downloads a source tarball
#   2. Extracts it
#   3. Runs ./configure with a local prefix (~/.local)
#   4. Compiles with make
#   5. Installs into ~/.local
#
# REQUIREMENTS:
#   - gcc
#   - make
#   - wget or curl
#
# USAGE:
#   ./install-from-source.sh <package-name> <tarball-url>
#
# EXAMPLE (rsync):
#   ./install-from-source.sh rsync \
#   https://download.samba.org/pub/rsync/src/rsync-3.2.7.tar.gz
#
###############################################################################

set -e  # Stop immediately if a command fails

############################
# 1. Validate input
############################

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <package-name> <tarball-url>"
  exit 1
fi

PACKAGE_NAME="$1"
TARBALL_URL="$2"

############################
# 2. Define install paths
############################

PREFIX="$HOME/.local"
SRC_DIR="$HOME/src"

mkdir -p "$SRC_DIR"
mkdir -p "$PREFIX"

cd "$SRC_DIR"

############################
# 3. Download source
############################

echo "Downloading source..."

if command -v wget >/dev/null 2>&1; then
  wget "$TARBALL_URL"
elif command -v curl >/dev/null 2>&1; then
  curl -LO "$TARBALL_URL"
else
  echo "Error: Neither wget nor curl found."
  exit 1
fi

TARBALL_FILE=$(basename "$TARBALL_URL")

############################
# 4. Extract source
############################

echo "Extracting..."

tar -xf "$TARBALL_FILE"

# Attempt to detect extracted folder automatically
EXTRACTED_DIR=$(tar -tf "$TARBALL_FILE" | head -1 | cut -f1 -d"/")

cd "$EXTRACTED_DIR"

############################
# 5. Configure build
############################

echo "Configuring build..."

# Disable optional features commonly missing on shared hosting
./configure \
  --prefix="$PREFIX" \
  --disable-xxhash \
  --disable-zstd \
  --disable-lz4 || {
    echo "Configure failed. Check missing dependencies."
    exit 1
  }

############################
# 6. Compile
############################

echo "Compiling..."

make -j$(nproc)

############################
# 7. Install
############################

echo "Installing into $PREFIX..."

make install

############################
# 8. Update PATH if needed
############################

if ! grep -q 'export PATH=$HOME/.local/bin:$PATH' "$HOME/.bashrc"; then
  echo 'export PATH=$HOME/.local/bin:$PATH' >> "$HOME/.bashrc"
  echo "PATH updated in ~/.bashrc"
fi

echo "Installation complete."
echo "Run: source ~/.bashrc"
echo "Then verify with:"
echo "$PACKAGE_NAME --version"

# How to use
# Example 1
./install-from-source.sh rsync \
https://download.samba.org/pub/rsync/src/rsync-3.2.7.tar.gz

# Example 2
./install-from-source.sh htop \
https://github.com/htop-dev/htop/archive/3.3.0.tar.gz
