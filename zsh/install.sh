#!/bin/bash

suffix=$(date +%s)
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))

[[ -f "$HOME/.zshrc" || -L "$HOME/.zshrc" ]] && mv "$HOME/.zshrc" "$HOME/.zshrc.${suffix}.bak"
ln -s "$curdir/.zshrc" "$HOME/.zshrc"

