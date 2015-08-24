#!/usr/bin/env bash

suffix=$(date +%s)
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))
src="$curdir/.gitconfig"
dest="$HOME/.gitconfig"

[[ -f "$dest" || -L "$dest" ]] && mv "$dest" "${dest}.${suffix}.bak"
ln -s "$src" "$dest"

