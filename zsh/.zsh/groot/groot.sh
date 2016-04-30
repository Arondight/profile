#!/usr/bin/env cat
# ==============================================================================
# 跳到git 仓库顶层目录
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

function groot ()
{
  local GDIRNAME='.git'
  local ROOTDIR='/'
  local topdir=$(readlink -f $(pwd))

  while [[ ! -d "${topdir}/${GDIRNAME}" && $ROOTDIR != $topdir ]]
  do
    topdir=$(readlink -f "${topdir}/..")
  done

  if [[ $ROOTDIR == $topdir ]]
  then
    echo "Not a git repository." >&2
    return 1
  else
    cd $topdir
  fi

  return $?
}

