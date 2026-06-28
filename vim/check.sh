#!/usr/bin/env bash
# ==============================================================================
# Check for installtion of vim's profiles
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

# MAIN:
{
  ret=0

  echo -ne "Checking vim ...\t"
  if ! type vim >/dev/null 2>&1
  then
    echo 'failed'
    ret=1
  else
    echo 'ok'
  fi

  echo -ne "Checking clang ...\t"
  if ! type clang >/dev/null 2>&1
  then
    echo 'failed'
    ret=1
  else
    echo 'ok'
  fi

  echo -ne "Checking clangd ...\t"
  if ! type clangd >/dev/null 2>&1
  then
    echo 'failed'
    ret=1
  else
    echo 'ok'
  fi

  exit $ret
}
