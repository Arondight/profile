#!/usr/bin/env cat
# shellcheck shell=bash
# ==============================================================================
# 跳到 git 仓库顶层目录
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

function groot ()
{
  local _gdirname='.git'
  local _rootdir='/'
  local _topdir
  _topdir="$(readlink -f "$PWD")"

  while [[ ! -d "${_topdir}/${_gdirname}" && "$_rootdir" != "$_topdir" ]]
  do
    _topdir=$(readlink -f "${_topdir}/..")
  done

  if [[ "$_rootdir" == "$_topdir" ]]
  then
    echo "Not a git repository." >&2
    return 1
  else
    cd "$_topdir" || return 1
  fi

  return "$?"
}

