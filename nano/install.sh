#!/usr/bin/env bash

suffix=$(date +%s)
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))
src_nanorc="$curdir/.nanorc"
src_plugin="$curdir/.nano"
dest_nanorc="$HOME/.nanorc"
dest_plugin="$HOME/.nano"

echo -ne "配置nano...\t"
[[ -f "$dest_nanorc" || -L "$dest_nanorc" ]] && mv "$dest_nanorc" "${dest_nanorc}.${suffix}.bak"
ln -s "$src_nanorc" "$dest_nanorc"
[[ -d "$dest_plugin" ||  -L "$dest_plugin" ]] && mv "$dest_plugin" "${dest_plugin}.${suffix}.bak"
ln -s "$src_plugin" "$dest_plugin"
echo '完成'

