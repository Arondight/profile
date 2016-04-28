#!/usr/bin/env bash
# ==============================================================================
# Check for installtion of nano's profiles
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

# MAIN:
{
  ret=0

  echo -ne "Checking nano ...\t"
  if ! type nano >/dev/null 2>&1; then
    echo 'warning'
  else
    echo 'ok'
  fi

  exit $ret
}

