#!/usr/bin/env bash

if [[ -r ./.gitconfig ]]; then
  ln -s $(readlink -f ./.gitconfig) $HOME/.gitconfig
fi

