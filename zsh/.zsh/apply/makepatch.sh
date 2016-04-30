#!/usr/bin/env cat
# ==============================================================================
# 制作补丁
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

alias mkpatch='makepatch'

function makepatch () {
  local DIFFCMD='diff'
  local base=$1
  local target=$2
  local patch=$3

  if [[ -z $base || -z $target || -z $patch ]]; then
    echo "Usage: makepatch <base> <target> <patch>"
    return 1
  fi

  if [[ ! -e $base ]]; then
    echo "\"$base\" is not exist, quit."
    return 1
  fi

  if [[ ! -e $target ]]; then
    echo "\"$target\" is not exist, quit."
    return 1
  fi

  if [[ -e $patch ]]; then
    echo "\"$patch\" has already exist, quit and do nothing."
    return 1
  fi

  # XXX: Dose -a is ok here?
  command $DIFFCMD -N -u -r -a $base $target >$patch

  return $?
}

