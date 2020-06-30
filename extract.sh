#!/bin/bash
# function Extract for common file formats

function extract {
  local EXIT_CODE=0
  local TMPDIR=
  local VERBOSE=1
  local KEEP=0
  local -a VERBOSE_FLAG
  local -a KEEP_FLAG

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
    VERBOSE_FLAG=()
    KEEP_FLAG=()
    TMPDIR=

    case $n in
      -v) VERBOSE=0 ; continue ;;
      -V) VERBOSE=1 ; continue ;;
      -k) KEEP=0    ; continue ;;
      -K) KEEP=1    ; continue ;;
      *)  ;;
    esac

    if [ ! -f "$n" ] ; then
      echo "'$n' - file does not exist" >&2
      EXIT_CODE="$((EXIT_CODE + 1))"
      continue
    fi
    if [ "${VERBOSE}" -eq 1 ] ; then
      echo "===> Extracting: $n <===" >&2
    fi

    case "${n%,}" in
      *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                              test "${VERBOSE}" -eq 0 && VERBOSE_FLAG=(v)
                              tar "${VERBOSE_FLAG[*]}"xf "$n"       ;;
      *.lzma)                 unlzma ./"$n"      ;;
      *.bz2)                  test "${KEEP}" -eq 0 && KEEP_FLAG=(-k)
                              bunzip2 "${KEEP_FLAG[@]}" ./"$n"     ;;
      *.cbr|*.rar)            unrar x -ad ./"$n" ;;
      *.gz)                   test "${KEEP}" -eq 0 && KEEP_FLAG=(-k)
                              gunzip "${KEEP_FLAG[@]}" ./"$n"      ;;
      *.cbz|*.epub|*.zip|*.whl)
        # We test quiet instead
        test "${VERBOSE}" -eq 1 && VERBOSE_FLAG=(-q)
        unzip "${VERBOSE_FLAG[@]}" ./"$n"
      ;;
      *.z)                    uncompress ./"$n"  ;;
      # ar is better for *.deb files
      *.deb)
        test "${VERBOSE}" -eq 0 && VERBOSE_FLAG=(v)

        # ar extracts "here", and debfiles have
        # multiple and similarly-named files
        TMPDIR="$(basename "$n")"
        (
          set -Eeuo pipefail
          mkdir "${TMPDIR}"
          cd "${TMPDIR}"
          ar "${VERBOSE_FLAG[*]}"x ../"$n"
        )
        # shellcheck disable=SC2181
        if [ "$?" -ne 0 ] ; then
          echo "Failed to extract '$n' in '$(realpath "${TMPDIR}")'" >&2
        fi
      ;;
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
