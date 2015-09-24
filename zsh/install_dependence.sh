#!/usr/bin/env bash

# oh-my-zsh
if [[ ! -d $HOME/.oh-my-zsh ]];then
  git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

# zsh-syntax-highlighting
if [[ ! -d $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting ]];then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
fi

# zsh-completions
if [[ ! -d $HOME/.oh-my-zsh/plugins/zsh-completions ]]; then
  git clone https://github.com/zsh-users/zsh-completions.git  \
            $HOME/.oh-my-zsh/plugins/zsh-completions
fi

# for possible insecure directories
chmod g-w -R $HOME/.oh-my-zsh

