#!/usr/bin/env cat
# shellcheck shell=bash
# ==============================================================================
# 在 Vim 中查看 Manual
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

function vimman ()
{
  local _section=''
  local _key=''

  if [[ "$#" -lt 1 ]]
  then
    return 0
  fi

  for _key in "$@"
  do
    if echo "$_key" | grep -P '^[1-9]$' >/dev/null 2>&1
    then
      _section="$_key"
    else
      vim -c "Man ${_section} ${_key}" -c 'only'
    fi
  done

  return "$?"
}

