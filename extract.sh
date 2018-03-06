#!/bin/bash
# function Extract for common file formats

function have_prog {
    [ -x "$(command -v $1)" ]
}

function check_extractors {
 if have_prog apt-get ; then package_manager="sudo apt-get install"
 else
    echo 'No package manager found!'
    exit 2
 fi
 if ! have_prog zpaq; then
    eval $package_manager zpaq
 elif ! have_prog unace; then
    eval $package_manager unace-nonfree
 elif ! have_prog arc; then
    eval $package_manager arc
 elif ! have_prog ciso; then
    eval $package_manager ciso
 else
    echo "error"
    return 1
 fi
}

function extract {
    check_extractors
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar|*.apk)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.zpaq)      zpaq x ./"$n"      ;;
            *.ace)       unace e ./"$n"     ;;
            *.arc)       arc e ./"$n"       ;;
            *.cso)       ciso 0 ./"$n" ./"$n.iso" && extract $n.iso && \rm -f $n ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}
