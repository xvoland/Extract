#!/bin/bash
# function Extract for common file formats

SAVEIFS=$IFS
IFS="$(printf '\n\t')"
local ABORT=


function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip rar bz2 gz tar tbz2 tgz Z 7z xz ex tar.bz2 tar.gz tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
  fi

  for n in "$@"
  do
    if [ ! -f "$n" ] ; then
        echo "'$n' - file does not exist, aborting"
        ABORT=yes
    fi
  done

  [ $ABORT ] && return 2

  for n in "$@"
  do
    case "${n%,}" in
      *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                   tar xvf "$n"       ;;
      *.lzma)      unlzma ./"$n"      ;;
      *.bz2)       bunzip2 ./"$n"     ;;
      *.cbr|*.rar)       unrar x -ad ./"$n" ;;
      *.gz)        gunzip ./"$n"      ;;
      *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
      *.z)         uncompress ./"$n"  ;;
      *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                   7z x ./"$n"        ;;
      *.xz)        unxz ./"$n"        ;;
      *.exe)       cabextract ./"$n"  ;;
      *.cpio)      cpio -id < ./"$n"  ;;
      *.cba|*.ace)      unace x ./"$n"      ;;
      *)
                   echo "\e[31mextract: '$n' - unknown archive extraction method\e[0m"
                   return 3
                   ;;
    esac
  done
}

IFS=$SAVEIFS
