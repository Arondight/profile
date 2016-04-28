#!/usr/bin/env bash
# ==============================================================================
# Check for installtion of zsh's profiles
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

# MAIN:
{
  ret=0

  echo -ne "Checking zsh ...\t"
  if ! type zsh >/dev/null 2>&1; then
    echo 'warning'
  else
    echo 'ok'
  fi

  exit $ret
}

