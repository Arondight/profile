#!/usr/bin/env bash
# =========================
# interface.sh
# =========================
# 你或许想这样使用:
# bash --init-file ~/.bash/interface.sh
#
#           By 秦凡东
# =========================
# Life is short, use Z Shell

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

