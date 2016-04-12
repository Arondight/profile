#!/usr/bin/env bash

if [[ -r ./.tigrc ]]; then
  ln -s $(readlink -f ./.tigrc) $HOME/.tigrc
fi

