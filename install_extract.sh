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


# Set the target path for installation
TARGET_PATH="/usr/local/bin/extract"

# Check if the file already exists
if [ -f "$TARGET_PATH" ]; then
    read -p "$TARGET_PATH already exists. Do you want to overwrite it? (y/n): " choice
    case "$choice" in
        y|Y )
            echo "Overwriting $TARGET_PATH..."
            ;;
        n|N )
            echo "Installation aborted."
            exit 0
            ;;
        * )
            echo "Invalid input. Installation aborted."
            exit 1
            ;;
    esac
fi

# Download the extract.sh script from GitHub
echo "Downloading extract.sh..."
curl -L -o /tmp/extract.sh https://raw.githubusercontent.com/xvoland/Extract/master/extract.sh

# Check for required utilities
REQUIRED_TOOLS=("unzip" "tar" "unrar" "gunzip" "7z" "unlzma" "bzip2" "xz" "cabextract" "zstd")
MISSING_TOOLS=()

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING_TOOLS+=("$tool")
    fi
done

if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    echo "Error: The following required utilities are missing:"
    printf ' - %s\n' "${MISSING_TOOLS[@]}"
    echo "Please install them before continuing."
    exit 1
fi

# Copy the script to the target directory
echo "Copying extract.sh to $TARGET_PATH..."
sudo mv /tmp/extract.sh $TARGET_PATH

# Make the script executable
echo "Setting executable permissions..."
sudo chmod +x $TARGET_PATH

echo "Installation complete! You can now use the 'extract' command to extract files."
