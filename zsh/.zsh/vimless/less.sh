#!/usr/bin/env cat
# shellcheck shell=bash
# ==============================================================================
# 使用 Vim 作为 less 程序
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

function vimless ()
{
  local _pager=()

  if type vim >/dev/null 2>&1
  then
    _pager=(vim -c 'set nofoldenable' -c 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim')
  elif type nano >/dev/null 2>&1
  then
    _pager=(nano -v)
  else
    less "$@"
    return "$?"
  fi

  if [[ 0 -eq "$#" ]]
  then
    if [[ -t 0 ]]
    then
      echo "Missing filename" >&2
      return 1
    fi
    if [[ ! -t 1 ]]
    then
      cat
      return "$?"
    fi
    "${_pager[@]}" -
    return "$?"
  fi

  if [[ ! -t 1 ]]
  then
    cat "$@"
    return "$?"
  fi

  "${_pager[@]}" -- "$@"
  return "$?"
}