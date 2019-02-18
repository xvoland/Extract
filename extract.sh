#!/bin/bash
# function Extract for common file formats

function extract {
  local EXIT_CODE=0

  if [ -z "$1" ]; then
    # display usage if no parameters given
    {
      echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
      echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
      echo
      echo "Exit Code: 0 - all okay, 1-125: # of input files / archives not processed"
      echo "           126 - show help"
      echo "           127 - (reserved)"
    } >&2

    return 126
  fi

  for n ; do
    if [ ! -f "$n" ] ; then
      echo "'$n' - file does not exist" >&2
      EXIT_CODE="$((EXIT_CODE + 1))"
      continue
    fi

    case "${n%,}" in
      *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                              tar xvf "$n"       ;;
      *.lzma)                 unlzma ./"$n"      ;;
      *.bz2)                  bunzip2 ./"$n"     ;;
      *.cbr|*.rar)            unrar x -ad ./"$n" ;;
      *.gz)                   gunzip ./"$n"      ;;
      *.cbz|*.epub|*.zip)     unzip ./"$n"       ;;
      *.z)                    uncompress ./"$n"  ;;
      *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                              7z x ./"$n"        ;;
      *.xz)                   unxz ./"$n"        ;;
      *.exe)                  cabextract ./"$n"  ;;
      *.cpio)                 cpio -id < ./"$n"  ;;
      *.cba|*.ace)            unace x ./"$n"     ;;
      *.zpaq)                 zpaq x ./"$n"      ;;
      *.arc)                  arc e ./"$n"       ;;
      *.cso)                  ciso 0 ./"$n" ./"$n.iso" && extract "$n.iso" && command rm -f "$n" ;;
      *)
        echo "extract: '$n' - unknown archive method"

        EXIT_CODE="$((EXIT_CODE + 1))"
        continue
      ;;
      esac
  done

  return "${EXIT_CODE}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  extract "$@"
fi
