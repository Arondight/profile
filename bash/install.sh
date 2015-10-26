#!/usr/bin/env bash

suffix=$(date +%s)
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))

[[ -e "$HOME/.bash" || -L "$HOME/.bash" ]] && mv "$HOME/.bash" "$HOME/.bash.${suffix}.bak"
[[ -f "$HOME/.bashrc" || -L "$HOME/.bashrc" ]] && mv "$HOME/.bashrc" "$HOME/.bashrc.${suffix}.bak"

echo -ne "配置bash...\t"
ln -sf "$curdir/.bashrc" "$HOME/.bashrc"
ln -sf "$curdir/.bash" "$HOME/.bash"
echo '完成'

