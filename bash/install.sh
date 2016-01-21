#!/usr/bin/env bash

suffix=$(date +'%Y-%m-%d_%T')
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))

if [[ ! -d $HOME/.bash ]]; then
  mkdir -p $HOME/.bash
fi
if [[ -f "$HOME/.bashrc" || -L "$HOME/.bashrc" ]]; then
  mv "$HOME/.bashrc" "$HOME/.bashrc.${suffix}.bak"
fi

echo -ne "配置bash...\t"
ln -sf "$curdir/.bashrc" "$HOME/.bashrc"
ln -sf "$curdir/.bash/interface.sh" "$HOME/.bash/interface.sh"
echo '完成'

