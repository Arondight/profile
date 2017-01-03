#!/usr/bin/env cat
# ==============================================================================
# 在Vim 中查看Manual
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

function vman ()
{
  local _section=''
  local _key=''

  if [[ "$#" < 1 ]]
  then
    return 0
  fi

  for _key in $@
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

