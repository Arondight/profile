#!/usr/bin/env bash

suffix=$(date +%s)

# vim plugins
#[[ -d "$HOME/.vim" ]] && mv "$HOME/.vim" "$HOME/.vim.${suffix}.bak"
#git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#vim -c 'PluginInstall' -c 'qa'

# vimproc.vim
cd ~/.vim/bundle/vimproc.vim
make

# color_coded
cd ~/.vim/bundle/color_coded
mkdir build && cd build
cmake ..
make install

# ycm
buildpara="--clang-completer"
[[ -e /usr/lib/libclang.so ]] && buildpara="$buildpara --system-libclang"
[[ -e /usr/bin/go ]] && buildpara="$buildpara --gocode-completer"
type xbuild >/dev/null 2>&1 && buildpara="$buildpara --omnisharp-completer"
cd ~/.vim/bundle/YouCompleteMe
git submodule update --init --recursive
python2 install.py $buildpara

