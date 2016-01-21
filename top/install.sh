#!/usr/bin/env bash

suffix=$(date +'%Y-%m-%d_%T')
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))
src="$curdir/.toprc"
dest="$HOME/.toprc"

[[ -f "$dest" || -L "$dest" ]] && mv "$dest" "${dest}.${suffix}.bak"

echo -ne "配置top...\t"
ln -s "$src" "$dest"
echo '完成'

