#!/usr/bin/env bash

if [[ -r ./.gitconfig ]]; then
  cp -f $(readlink -f ./.gitconfig) $HOME/.gitconfig
fi

