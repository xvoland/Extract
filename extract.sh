#!/bin/bash
#
# Extract common file formats effortlessly
#
# Author: xVoLAnD <xvoland@gmail.com>
# Author: Stdedos <133706+stdedos@users.noreply.github.com>

in_temp() {
  set -Eeuo pipefail

  in_dir="$(mktemp -dp . "${n}-XXXXX")"
  >&2 echo "Copying (hardlink) '$n' in '${in_dir}/$n'"

  cp -l "$1" "${in_dir}/$n"
  echo "${in_dir}"
}

extractable_extesions() {
  grep -oP '(?<=\*\.)[\w.]+' "$0" | tr '\n' '|' | sed 's/.$//'
  [ -t 1 ] || echo
}

function extract {
  local EXIT_CODE=0
  local VERBOSE=1
  local KEEP=0
  local FORCE_DIR=1
  local in_dir
  local name
  local -a VERBOSE_FLAG
  local -a KEEP_FLAG

  name="${FUNCNAME[0]}"
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]] && command -V perl &> /dev/null ; then
    name="$(perl -pe "s#($(tr ':' '|' <<< "${PATH}"))/##g" <<< "$0")"
  fi

  if [ -z "$1" ] || [[ "$*" =~ (^|\s)(-h|--help)(\s|$) ]] ; then
    # display usage if no parameters given or -h/--help at arguments
    {
      echo "${name}: magically extract any kind of archive"
      printf "  Includes:"
      extractable_extesions | sed 's/|/, /g' | fold --space | sed 's/^/  /g'
      echo
      echo "Usage:"
      echo "  ${name} -h|--help"
      echo "  ${name} [-v|-V] [-k|-K] [-D] path/file_name_1.ext ..."
      echo
      echo "Note that you may want to \`cd\` to the directory you want to extract to!"
      echo
      echo "Exit Code:"
      echo "  0     - all okay"
      echo "  1-125 - # of input files / archives not processed"
      echo "  126   - show help"
      echo "  127   - (reserved)"
    } >&2

    return 126
  fi

  for n ; do
    VERBOSE_FLAG=()
    KEEP_FLAG=()
    in_dir=

    case $n in
      -v) VERBOSE=0     ; continue ;;
      -V) VERBOSE=1     ; continue ;;
      -k) KEEP=0        ; continue ;;
      -K) KEEP=1        ; continue ;;
      -D) FORCE_DIR=0   ; continue ;;
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

    if [ "${FORCE_DIR}" -eq 0 ] ; then
      if ! in_dir="$(in_temp "$n")" ; then
        echo "Failed to prepare '$n' for extraction!" >&2
      fi
      if ! (cd "${in_dir}" && extract "$n") ; then
        EXIT_CODE="$((EXIT_CODE + 1))"
      fi
      continue
    fi

    case "${n%,}" in
      *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                              test "${VERBOSE}" -eq 0 && VERBOSE_FLAG=(v)
                              tar "${VERBOSE_FLAG[*]}"xf "$n"       ;;
      *.lzma)                 unlzma "$n"      ;;
      *.bz2)                  test "${KEEP}" -eq 0 && KEEP_FLAG=(-k)
                              bunzip2 "${KEEP_FLAG[@]}" "$n"     ;;
      *.cbr|*.rar)            unrar x -ad "$n" ;;
      *.gz)                   test "${KEEP}" -eq 0 && KEEP_FLAG=(-k)
                              gunzip "${KEEP_FLAG[@]}" "$n"      ;;
      *.docx|*.xlsx)
        if ! in_dir="$(in_temp "$n")" ; then
          echo "Failed to prepare '$n' for extraction!" >&2
        fi
      ;&
      *.cbz|*.epub|*.zip|*.whl|*.war)
        # We test quiet instead
        test "${VERBOSE}" -eq 1 && VERBOSE_FLAG=(-q)
        (
          if [ -n "${in_dir}" ] ; then
            cd "${in_dir}" || exit $?
          fi
          unzip "${VERBOSE_FLAG[@]}" "$n"
        )
      ;;
      *.z)                    uncompress "$n"  ;;
      # ar is better for *.deb files
      *.deb)
        test "${VERBOSE}" -eq 0 && VERBOSE_FLAG=(v)

        # ar extracts "here", and debfiles have
        # multiple and similarly-named files
        if ! in_dir="$(in_temp "$n")" ; then
          echo "Failed to prepare '$n' for extraction!" >&2
        fi
        (cd "${in_dir}" && ar "${VERBOSE_FLAG[*]}"x "$n")
      ;;
      *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                              7z x "$n"        ;;
      *.xz)                   unxz "$n"        ;;
      *.exe)                  cabextract "$n"  ;;
      *.cpio)                 cpio -id < "$n"  ;;
      *.cba|*.ace)            unace x "$n"     ;;
      *.zpaq)                 zpaq x "$n"      ;;
      *.arc)                  arc e "$n"       ;;
      *.cso)                  ciso 0 "$n" "$n.iso" && extract "$n.iso" && command rm -f "$n" ;;
      *)
        >&2 echo "extract: '$n' - unknown archive method"
        (exit 1)
      ;;
      esac

      # shellcheck disable=SC2181
      if [ "$?" -ne 0 ] ; then
        EXIT_CODE="$((EXIT_CODE + 1))"
      fi
  done

  return "${EXIT_CODE}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  extract "$@"
fi
