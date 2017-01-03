#!/usr/bin/env cat
# ==============================================================================
# 撤销补丁
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

function unapply ()
{
  local _patchcmd='patch'
  local _stripLevel="$1"
  local _file="$2"

  if [[ -z "$_file" || -z "$_stripLevel" ]]
  then
    echo "Usage: unapply <strip> <patch-file>"
    return 1
  fi

  if ! echo "$_stripLevel" | grep -P '\d+' 2>&1 >/dev/null
  then
    echo "<strip> should be a integer, quit."
    return 1
  fi

  if [[ ! -r "$_file" ]]
  then
    echo "\"${_file}\" can not be read, quit."
    return 1
  fi

  command "$_patchcmd" -R -E -p "$_stripLevel" <"$_file"

  return "$?"
}

