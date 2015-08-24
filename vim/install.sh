#!/usr/bin/env bash

suffix=$(date +%s)
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))
src_vimrc="$curdir/.vimrc"
src_ycmrc="$curdir/.ycm_extra_conf.py"
dest_vimrc="$HOME/.vimrc"
dest_ycmrc="$HOME/.ycm_extra_conf.py"
dest_plugin="$HOME/.vim"

[[ -f "$dest_vimrc" || -L "$dest_vimrc" ]] && mv "$dest_vimrc" "${dest_vimrc}.${suffix}.bak"
[[ -d "$dest_plugin" || -L "$dest_plugin" ]] && mv "$dest_plugin" "${dest_plugin}.${suffix}.bak"
if [[ -f "$dest_ycmrc" || -L "$dest_ycmrc" ]]; then
  mv "$dest_ycmrc" "${dest_ycmrc}.${suffix}.bak"
fi

echo -ne "配置vim...\t"
ln -s "$src_vimrc" "$dest_vimrc"
ln -s "$src_ycmrc" "$dest_ycmrc"
echo '完成'

