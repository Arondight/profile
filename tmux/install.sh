#!/bin/bash

suffix=$(date +%s)
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))

[[ -f "$HOME/.tmux.conf" || -L "$HOME/.tmux.conf" ]] && mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.${suffix}.bak"
ln -s "$curdir/.tmux.conf" "$HOME/.tmux.conf"

