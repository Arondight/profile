#!/bin/sh

suffix=$(date +%s)
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))

[[ -f "$HOME/.toprc" || -L "$HOME/.toprc" ]] && mv "$HOME/.toprc" "$HOME/.toprc.${suffix}.bak"
ln -s "$curdir/.toprc" "$HOME/.toprc"

