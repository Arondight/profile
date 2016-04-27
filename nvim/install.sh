#!/usr/bin/env bash

suffix=$(date +'%Y-%m-%d_%T')
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))
src_nvimrc="$HOME/.vimrc"
dest_nvimrc="$HOME/.config/nvim/init.vim"

[[ ! -d $HOME/.config/nvim ]] && mkdir -p $HOME/.config/nvim
[[ -f "$dest_nvimrc" || -L "$dest_nvimrc" ]] && mv "$dest_nvimrc" "${dest_nvimrc}.${suffix}.bak"

echo -ne "配置nvim...\t"
ln -sf "$src_nvimrc" "$dest_nvimrc"
echo '完成'

