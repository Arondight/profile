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
  local _profileroot
  _profileroot="$(dirname "$(dirname "$(readlink -f "$HOME/.zshrc")")")"
  local _install_sh="${_profileroot}/install.sh"
  local _args='-a'
  local _ret=0

  pushd "$_profileroot" || return 1
  {

  if [[ -x "$_install_sh" ]]
  then
    command "$_install_sh" "$_args"
    _ret="$?"
  else
    echo "\"${_install_sh}\" not found." >&2
    _ret=1
  fi

  }
  popd || return 1

  return "$_ret"
}

