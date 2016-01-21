#!/usr/bin/env bash

suffix=$(date +'%Y-%m-%d_%T')
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))
src="$curdir/config"
dest="$HOME/.mplayer/config"

if [[ -d "$HOME/.mplayer" ]]; then
  if [[ -f "$dest" || -L "$dest" ]]; then
    mv "$dest" "${dest}.${suffix}.bak"
  fi
else
  mkdir "$HOME/.mplayer"
fi

echo -ne "配置mplayer...\t"
ln -s "$src" "$dest"
echo '完成'

