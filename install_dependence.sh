#!/bin/sh

# oh-my-zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]];then
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

# zsh-syntax-highlighting
if [[ ! -d  ~/.zsh/zsh-syntax-highlighting ]];then
  git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
fi

# vim plugins
suffix=$(date +%s)
[[ -d "$HOME/.vim" ]] && mv "$HOME/.vim" "$HOME/.vim.${suffix}.bak"
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c ':BundleInstall' -c ':q' -c ':q'

# ycm
buildpara="--clang-completer"
type clang >/dev/null 2>&1 && buildpara="$buildpara --system-libclang"
type xbuild >/dev/null 2>&1 && buildpara="$buildpara --omnisharp-completer"
cd ~/.vim/bundle/YouCompleteMe
. install.sh $buildpara

