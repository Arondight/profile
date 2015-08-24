#!/usr/bin/env bash

suffix=$(date +%s)
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))
src="$curdir/redshift.conf"
dest="$HOME/.config/redshift.conf"

if [[ -d "$HOME/.config" ]]; then
  if [[ -f "$dest" || -L "$dest" ]]; then
    mv "$dest" "${dest}.${suffix}.bak"
  fi
else
  mkdir "$HOME/.config"
fi

echo -ne "配置redshift...\t"
ln -s "$src" "$dest"
echo '完成'

