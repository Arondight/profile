#!/usr/bin/env bash

suffix=$(date +%s)

# vim plugins
[[ -d "$HOME/.vim" ]] && mv "$HOME/.vim" "$HOME/.vim.${suffix}.bak"
git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
vim -c 'PluginInstall' -c 'qa'

# vimproc.vim
cd $HOME/.vim/bundle/vimproc.vim
make

# color_coded
cd $HOME/.vim/bundle/color_coded
mkdir build && cd build
cmake ..
make && make install

# ycm
sysclang=0
buildpara="--clang-completer"
clang_root=( $(find $HOME/.vim/bundle/color_coded/build -maxdepth 1 -type d -name 'clang*') )
clang_root=${clang_root[-1]}
[[ -z $clang_root ]] && [[ -e /usr/lib/libclang.so ]] && sysclang=1
type go >/dev/null 2>&1 && buildpara="$buildpara --gocode-completer"
type xbuild >/dev/null 2>&1 && buildpara="$buildpara --omnisharp-completer"
cd $HOME/.vim/bundle/YouCompleteMe
git submodule update --init --recursive
if [[ 1 == $sysclang ]]; then
  buildpara="$buildpara --system-libclang"
  python2 install.py $buildpara
elif [[ -n $clang_root ]]; then
  mkdir build
  cd build
  cmake -G "Unix Makefiles" \
        -DPATH_TO_LLVM_ROOT=$clang_root \
        . \
        $HOME/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
  make ycm_support_libs
else
  python2 install.py $buildpara
fi

