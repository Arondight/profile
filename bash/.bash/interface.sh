#!/usr/bin/env bash
# ==============================================================================
# interface.sh
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# Life is short, use Z Shell
# ==============================================================================

interface_dir="$HOME/.bash/interface"

if [[ ! -d $interface_dir ]]; then
  mkdir -p $interface_dir
fi

if [[ -d $interface_dir ]]; then
  for script in $HOME/.bash/interface/*.sh; do
    if [[ -r $script ]]; then
      source $script
    fi
  done
  unset script
fi

