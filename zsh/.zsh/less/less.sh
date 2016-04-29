#!/usr/bin/env cat
# ==============================================================================
# 使用Vim 作为less 程序
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

alias sysless='env less'

function less ()
{
  local input=''
  local pager=''

  if type vim >/dev/null 2>&1
  then
    pager="vim -c 'set nofoldenable' \
                      -c 'let no_plugin_maps = 1' \
                      -c 'runtime! macros/less.vim'"
  elif type nano >/dev/null 2>&1
  then
    pager='nano -v'
  else
    less $@
    return $?
  fi

  if [[ 0 -eq $# ]]
  then
    input='-'
    if [[ -t 0 ]]
    then
      echo "Missing filename" >&2
      return 1
    fi
  else
    input='$@'
  fi

  if [[ ! -t 1 ]]
  then
    if [[ 0 -eq $# ]]
    then
      cat
    else
      cat $@
    fi
    return $?
  fi

  eval $pager $input

  return $?
}

