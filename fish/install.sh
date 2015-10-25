#!/usr/bin/env bash

suffix=$(date +%s)
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))

[[ ! -d "$HOME/.config/fish" ]] && mkdir "$HOME/.config/fish"

echo -ne "配置fish...\t"
if [[ -L "$HOME/.config/fish/config.fish" ]]; then
  :
elif [[ -f "$HOME/.config/fish/config.fish" ]]; then
  cat "$curdir/config.fish" >> "$HOME/.config/fish/config.fish"
else
  ln -s "$curdir/config.fish" "$HOME/.config/fish/config.fish"
fi
echo '完成'

