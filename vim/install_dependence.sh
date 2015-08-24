#!/usr/bin/env bash

suffix=$(date +%s)

# vim plugins
[[ -d "$HOME/.vim" ]] && mv "$HOME/.vim" "$HOME/.vim.${suffix}.bak"
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c 'PluginInstall' -c 'qa'

# vimproc.vim
cd ~/.vim/bundle/vimproc.vim
make

# ycm
buildpara="--clang-completer"
[[ -e /usr/lib/libclang.so ]] && buildpara="$buildpara --system-libclang"
type xbuild >/dev/null 2>&1 && buildpara="$buildpara --omnisharp-completer"
cd ~/.vim/bundle/YouCompleteMe
. install.sh $buildpara

