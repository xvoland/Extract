#!/bin/bash

tmp_script=$(mktemp)
cp 'extract.sh' "$tmp_script"

# determine what syntax to use for sed
if sed --version 2>/dev/null | grep -q 'GNU'; then
    sed_inplace=(-i)
else
    sed_inplace=(-i '')
fi

# list of tools and corresponding templates
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
)

# list of missing tools
missing_patterns=()

for tool in "${!tools_patterns[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        echo -e "\033[33mwarning: $tool not found\033[0m" 1>&2
        missing_patterns+=("${tools_patterns[$tool]}")
    fi
done

# if there are missing tools, use sed with one command
if [[ ${#missing_patterns[@]} -gt 0 ]]; then
    sed "${sed_inplace[@]}" -e "$(printf "%s;" "${missing_patterns[@]}")" "$tmp_script"
fi

# results
echo ''
echo '# Github: https://github.com/xvoland/Extract/'
sed -e '/^#/d' -e '/^$/d' "$tmp_script"

rm "$tmp_script"
