#!/usr/bin/env bash
# ==============================================================================
# 重新初始化运行环境
# ==============================================================================
# Created by Arondight <shell_way@foxmail.com>
# ==============================================================================

alias profile-reconf='profilereconf'
alias profile_reconf='profilereconf'

function profilereconf ()
{
  local PROFILEROOT=$(dirname $(dirname $(readlink -f $HOME/.zshrc)))
  local INSTALL_SH="${PROFILEROOT}/install.sh"
  local ARGS='-a'
  local ret=0

  pushd $PROFILEROOT

  if [[ -x $INSTALL_SH ]]
  then
    command $INSTALL_SH $ARGS
    ret=$?
  else
    echo "\"${INSTALL_SH}\" not found." >&2
    ret=1
  fi

  popd

  return $?
}

