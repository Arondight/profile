#!/usr/bin/env cat
# ==============================================================================
# 跳到git 仓库顶层目录
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

function groot {
  local flagdir=".git"
  local topdir=$(readlink -f $(pwd))

  while [[ ! -d $topdir/$flagdir && "/" != $topdir ]]; do
    topdir=$(readlink -f $topdir/..)
  done

  if [[ "/" == $topdir ]]; then
    echo "当前目录不在git 仓库内"
    return 1
  else
    cd $topdir
  fi

  return $?
}

