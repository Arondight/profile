#!/usr/bin/env bash

if [[ -r ./.tigrc ]]; then
  ln -s $(readlink -f ./.gitconfig) $HOME/.tigrc
fi

