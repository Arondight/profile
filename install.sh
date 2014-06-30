#!/bin/sh

for path in $(pwd)/* ; do
  if [[ -d $path && -x $path/install.sh ]]; then
    curdir=$(dirname $(readlink -f "$path/install.sh"))
    . $path/install.sh
    unset curdir
  fi
done

[[ "--help" == $1 || "-h" == $1 ]] && echo "$0 [--with-dependence]"
[[ "--with-dependence" == $1 ]] && . ./install_dependence.sh

