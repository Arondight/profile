#!/usr/bin/env bash
# ==============================================================================
# Check for installtion of tmux's profiles
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

# MAIN:
{
  ret=0

  echo -ne "Checking tmux ...\t"
  if ! type tmux >/dev/null 2>&1; then
    echo 'warning'
  else
    echo 'ok'
  fi

  exit $ret
}

