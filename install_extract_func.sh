#!/bin/bash

# Create a temporary copy of extract.sh
tmp_script=$(mktemp)
cp 'extract.sh' "$tmp_script"

# Cleanup temp file on exit
trap 'rm -f "$tmp_script"' EXIT

# Determine the appropriate sed -i syntax (BSD/macOS vs GNU)
if sed --version 2>/dev/null | grep -q 'GNU'; then
    sed_inplace=(-i)
else
    sed_inplace=(-i '')
fi

# Map required tools to their matching case patterns in extract.sh
declare -A tools_patterns=(
    [bunzip2]='/\*\.bz2)/d'
    [unxz]='/\*\.xz)/d'
    [gunzip]='/\*\.gz)/d'
    [zstd]='/\*\.tar\.zst)/d;/\*\.zst)/d'
    [unrar]='/\*\.cbr|\*\.rar)/d'
    [unzip]='/\*\.cbz|\*\.epub|\*\.zip)/d'
    [7z]='/\*\.7z|\*\.apk|\*\.arj|\*\.cab|\*\.cb7|\*\.chm|\*\.deb|\*\.iso|\*\.lzh|\*\.msi|\*\.pkg|\*\.rpm|\*\.udf|\*\.wim|\*\.xar|\*\.vhd)/d'
    [arc]='/\*\.arc)/d'
    [unlzma]='/\*\.lzma)/d'
    [zpaq]='/\*\.zpaq)/d'
    [cpio]='/\*\.cpio)/d'
    [cabextract]='/\*\.exe)/d'
    [uncompress]='/\*\.z)/d'
    [unace]='/\*\.cba|\*\.ace)/d'
    [ciso]='/\*\.cso)/d'
    [zlib-flate]='/\*\.zlib)/d'
    [hdiutil]='/\*\.dmg)/d'
    [lz4]='/\*\.lz4)/d;/\*\.tar\.lz4)/d'
    [pbzip2]='/\*\.tar\.br)/d'
)

# Track missing tools and collect corresponding sed expressions
missing_patterns=()
for tool in "${!tools_patterns[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        echo -e "\033[33mwarning: $tool not found\033[0m" >&2
        missing_patterns+=("${tools_patterns[$tool]}")
    fi
done

# Remove lines for missing tools from the extract function
if [[ ${#missing_patterns[@]} -gt 0 ]]; then
    sed "${sed_inplace[@]}" -e "$(printf "%s;" "${missing_patterns[@]}")" "$tmp_script"
fi

# Final output: clean and ready-to-use extract function (without comments or blank lines)
echo ''
echo '# Github: https://github.com/xvoland/Extract/'
sed -E '/^\s*#/d;/^\s*$/d' "$tmp_script"
