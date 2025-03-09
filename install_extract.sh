#!/usr/bin/env bash

# Installer for the extract.sh script
#
# Example:
# $ install_extract.sh
#
# Author: Vitalii Tereshchuk, 2024
# Web:    https://dotoca.net
# Github: https://github.com/xvoland/Extract/blob/master/extract.sh
#

TARGET_PATH="/usr/local/bin/extract"
SCRIPT_URL="https://raw.githubusercontent.com/xvoland/Extract/master/extract.sh"
TMP_SCRIPT="/tmp/extract.sh"

# Check if 'curl' is installed
if ! command -v curl &>/dev/null; then
    echo "Error: 'curl' is required to download the script. Please install it first."
    exit 1
fi

# Check if the script is already installed
if [ -f "$TARGET_PATH" ]; then
    read -p "$TARGET_PATH already exists. Overwrite? (y/n): " choice
    case "$choice" in
        y|Y ) echo "Overwriting $TARGET_PATH..." ;;
        n|N ) echo "Installation aborted."; exit 0 ;;
        * ) echo "Invalid input. Installation aborted."; exit 1 ;;
    esac
fi

# Download extract.sh script from GitHub
echo "Downloading extract.sh..."
if ! curl -L -o "$TMP_SCRIPT" "$SCRIPT_URL"; then
    echo "Error: Failed to download extract.sh"
    exit 1
fi

# List of required tools for extraction
REQUIRED_TOOLS=("unzip" "tar" "unrar" "gunzip" "7z" "unlzma" "bzip2" "xz" "cabextract" "zstd")
MISSING_TOOLS=()

# Check if required tools are installed
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        MISSING_TOOLS+=("$tool")
    fi
done

# Warn the user about missing tools but continue installation
if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    echo "Warning: The following tools are missing, some formats may not be supported:"
    printf ' - %s\n' "${MISSING_TOOLS[@]}"
fi

# Check if the user has sudo privileges (if not root)
if [ "$(id -u)" -ne 0 ] && ! command -v sudo &>/dev/null; then
    echo "Error: You need sudo privileges to install the script in $TARGET_PATH."
    exit 1
fi

# Move the script to the target directory
echo "Installing extract.sh to $TARGET_PATH..."
sudo mv "$TMP_SCRIPT" "$TARGET_PATH"

# Set execute permissions
sudo chmod +x "$TARGET_PATH"

echo "Installation complete! Use 'extract' to extract files."
