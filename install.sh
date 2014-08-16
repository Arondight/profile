#!/bin/bash

if [[ "--help" == $1 || "-h" == $1 ]]; then
  echo "$0 [--with-dependence]"
  exit 0;
fi

for path in $(pwd)/* ; do
  if [[ -d $path && -x $path/install.sh ]]; then
    curdir=$(dirname $(readlink -f "$path/install.sh"))
    . $path/install.sh
    unset curdir
  fi
done

[[ "--with-dependence" == $1 ]] && . ./install_dependence.sh

