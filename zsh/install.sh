#!/usr/bin/env bash

suffix=$(date +'%Y-%m-%d_%T')
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))

[[ -f "$HOME/.zshrc" || -L "$HOME/.zshrc" ]] && mv "$HOME/.zshrc" "$HOME/.zshrc.${suffix}.bak"

echo -ne "配置zsh...\t"
ln -s "$curdir/.zshrc" "$HOME/.zshrc"
ln -sf "$curdir/.zsh" "$HOME/.zsh"
echo '完成'

