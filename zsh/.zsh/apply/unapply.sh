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
  local PATCHCMD='patch'
  local stripLevel=$1
  local file=$2

  if [[ -z $file || -z $stripLevel ]]
  then
    echo "Usage: unapply <strip> <patch-file>"
    return 1
  fi

  if ! echo $stripLevel | grep -P '\d+' 2>&1 >/dev/null
  then
    echo "<strip> should be a integer, quit."
    return 1
  fi

  if [[ ! -r $file ]]
  then
    echo "\"$file\" can not be read, quit."
    return 1
  fi

  command $PATCHCMD -R -E -p $stripLevel <$file

  return $?
}

