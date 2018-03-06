#!/bin/bash
# function Extract for common file formats

function have_prog {
    [ -x "$(command -v $1)" ]
}

function check_extractors {
 if   have_prog apt-get ; then package_manager="sudo apt-get install"
 elif have_prog yum     ; then package_manager="yum install"
 elif have_prog dnf     ; then package_manager="dnf install"
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
            *.tar.bz2|*.Tar.bz2|*.Tar.Bz2|*.tar.Bz2|*.tar.BZ2|*.TAR.bz2|*.TAR.BZ2|\
            *.tar.gz|*.Tar.gz|*.Tar.Gz|*.tar.Gz|*.tar.GZ|*.TAR.gz|*.TAR.GZ|\
            *.tar.xz|*.Tar.xz|*.Tar.Xz|*.tar.Xz|*.tar.XZ|*.TAR.xz|*.TAR.XZ|\
            *.tbz2|*.Tbz2|*.TBZ2|\
            *.tgz|*.Tgz|*.TGZ|\
            *.txz|*.Txz|*.TXZ|\
            *.tar|*.Tar|*.TAR) 
                                       tar xvf "$n"       ;;
            *.lzma|*.Lzma|*.LZMA)      unlzma ./"$n"      ;;
            *.bz2|*.Bz2|*.BZ2)         bunzip2 ./"$n"     ;;
            *.rar|*.Rar|*.RAR)         unrar x -ad ./"$n" ;;
            *.gz|*.Gz|*.GZ)            gunzip ./"$n"      ;;
            *.zip|*.Zip|*.ZIP)         unzip ./"$n"       ;;
            *.z|*.Z)                   uncompress ./"$n"  ;;
            *.7z|*.7Z|\
            *.apk|*.Apk|*.APK|\
            *.arj|*.Arj|*.ARJ|\
            *.cab|*.Cab|*.CAB|\
            *.chm|*.Chm|*.CHM|\
            *.deb|*.Deb|*.DEB|\
            *.dmg|*.Dmg|*.DMG|\
            *.iso|*.Iso|*.ISO|\
            *.lzh|*.Lzh|*.LZH|\
            *.msi|*.Msi|*.MSI|\
            *.rpm|*.Rpm|*.RPM|\
            *.udf|*.Udf|*.UDF|\
            *.wim|*.Wim|*.WIM|\
            *.xar|*.Xar|*.XAR)
                                       7z x ./"$n"        ;;
            *.xz|*.Xz|*.XZ)            unxz ./"$n"        ;;
            *.exe|*.Exe|*.EXE)         cabextract ./"$n"  ;;
            *.zpaq|*.Zpaq|*.ZPAQ)      zpaq x ./"$n"      ;;
            *.ace|*.Ace|*.ACE)         unace e ./"$n"     ;;
            *.arc|*.Arc|*.ARC)         arc e ./"$n"       ;;
            *.cso|*.Cso|*.CSO)       ciso 0 ./"$n" ./"$n.iso" && \
                              extract $n.iso && \rm -f $n ;;
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
