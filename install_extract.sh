#!/usr/bin/env bash

# Installer for the extract.sh script
#
# Downloads the latest extract.sh, checks dependencies, and installs it system-wide.
#
# Example:
#   $ ./install_extract.sh
#
# Author: Vitalii Tereshchuk, 2024
# Web:    https://dotoca.net
# Github: https://github.com/xvoland/Extract/blob/master/extract.sh

set -e

TARGET_PATH="/usr/local/bin/extract"
SCRIPT_URL="https://raw.githubusercontent.com/xvoland/Extract/master/extract.sh"
TMP_SCRIPT="$(mktemp)"

# Check if 'curl' is installed
if ! command -v curl &>/dev/null; then
    echo "Error: 'curl' is required to download the script. Please install it first."
    exit 1
fi

# Check for existing installation
if [ -f "$TARGET_PATH" ]; then
    read -p "$TARGET_PATH already exists. Overwrite? (y/n): " choice
    case "$choice" in
        y|Y ) echo "Overwriting $TARGET_PATH..." ;;
        n|N ) echo "Installation aborted."; exit 0 ;;
        * ) echo "Invalid input. Installation aborted."; exit 1 ;;
    esac
fi

# Download extract.sh from GitHub
echo "Downloading extract.sh from GitHub..."
if ! curl -fsSL -o "$TMP_SCRIPT" "$SCRIPT_URL"; then
    echo "Error: Failed to download extract.sh"
    exit 1
fi

# Required tools used by extract.sh
REQUIRED_TOOLS=(
    "unzip" "tar" "unrar" "gunzip" "7z" "unlzma" "bunzip2" "xz" "cabextract" "zstd" "lz4"
    "zlib-flate" "cpio" "uncompress" "ciso" "arc" "zpaq" "unace" "hdiutil" "pbzip2"
)

MISSING_TOOLS=()

# Detect missing tools
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        MISSING_TOOLS+=("$tool")
    fi
done

# Warn but proceed with installation
if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    echo "⚠️  Warning: The following tools are missing and some formats may not be supported:"
    for t in "${MISSING_TOOLS[@]}"; do
        echo " - $t"
    done
    echo
fi

# Ensure sudo is available if not running as root
if [ "$(id -u)" -ne 0 ] && ! command -v sudo &>/dev/null; then
    echo "Error: You need sudo privileges to install the script to $TARGET_PATH."
    exit 1
fi

# Install the script
echo "Installing extract.sh to $TARGET_PATH..."
if [ "$(id -u)" -eq 0 ]; then
    mv "$TMP_SCRIPT" "$TARGET_PATH"
    chmod +x "$TARGET_PATH"
else
    sudo mv "$TMP_SCRIPT" "$TARGET_PATH"
    sudo chmod +x "$TARGET_PATH"
fi

echo "✅ Installation complete! You can now use the 'extract' command."
