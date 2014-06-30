#!/bin/sh

suffix=$(date +%s)
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))

[[ -f "$HOME/.vimrc" || -L "$HOME/.vimrc" ]] && mv "$HOME/.vimrc" "$HOME/.vimrc.${suffix}.bak"
[[ -d "$HOME/.vim" || -L "$HOME/.vim" ]] && mv "$HOME/.vim" "$HOME/.vim.${suffix}.bak"
if [[ -f "$HOME/.ycm_extra_conf.py" || -L "$HOME/.ycm_extra_conf.py" ]]; then
  mv "$HOME/.ycm_extra_conf.py" "$HOME/.ycm_extra_conf.py.${suffix}.bak"
fi
ln -s "$curdir/.vimrc" "$HOME/.vimrc"
ln -s "$curdir/.ycm_extra_conf.py" "$HOME/.ycm_extra_conf.py"

