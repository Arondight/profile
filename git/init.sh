#!/usr/bin/env bash

if [[ -r ./.gitconfig ]]; then
  ln -s $HOME/.gitconfig ./.gitconfig
fi

