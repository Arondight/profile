#!/usr/bin/env bash

suffix=$(date +%s)
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))
src="$curdir/config"
dest="$HOME/.config/terminator/config"

if [[ -d "$(dirname $dest)" ]]; then
  if [[ -f "$dest" || -L "$dest" ]]; then
    mv "$dest" "${dest}.${suffix}.bak"
  fi
else
  mkdir "$(dirname $dest)"
fi

echo -ne "配置terminator...\t"
ln -sf "$src" "$dest"
echo '完成'

