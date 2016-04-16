#!/usr/bin/env bash

if [[ -r ./pacman.conf ]]; then
  sudo cp -f $(readlink -f ./pacman.conf) /etc/pacman.conf
fi

