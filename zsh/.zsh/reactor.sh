#!/usr/bin/env bash
# ==============================================================================
# 注册自定义插件
# ==============================================================================
# Created by Arondight <shell_way@foxmail.com>
# ==============================================================================
# 在shell 配置文件中加入下列一行:
#   source $HOME/.zsh/reactor.sh
# ==============================================================================

if ! (type existcmd) >/dev/null 2>&1
then
  function existcmd ()
  {
    local cmd="$1"
    type "$cmd" 2>&1 >/dev/null
    return "$?"
  }
fi

# ==============================================================================
# 对path 进行去重
# ==============================================================================
function _uniqPath ()
{
  if ! existcmd 'perl'
  then
    return 1
  fi

  # XXX: 这里的去重考虑使用sed/awk 重写
  export PATH="$(
    perl -E 'print join ":", grep { ++$_{$_} < 2 } split ":", $ENV{PATH}'
  )"

  return "$?"
}

# ==============================================================================
# 对fpath 进行去重
# ==============================================================================
function _uniqFpath ()
{
  if ! existcmd 'perl'
  then
    return 1
  fi

  # XXX: 这里的去重考虑使用sed/awk 重写
  export FPATH="$(
    echo -n $FPATH | perl -anF/:/ -E 'print join ":", grep { ++$_{$_} < 2 } @F'
  )"

  return "$?"
}

# ==============================================================================
# PATH
# ==============================================================================
function myPathLoader ()
{
  local MYPATHDIR="${HOME}/.zsh/path"

  if [[ -d "$MYPATHDIR" ]]
  then
    for script in "${MYPATHDIR}"/*.sh
    do
      if [[ -r "$script" ]]
      then
        source "$script"
      fi
    done
    unset 'script'
  fi

  # 当前目录必须*最后*添加
  export PATH="${PATH}:."

  return "$?"
}

# ==============================================================================
# alias
# ==============================================================================
function myAliasLoader ()
{
  local MYALIAS_SH="${HOME}/.zsh/alias/alias.sh"

  if [[ -r "$MYALIAS_SH" ]]
  then
    source "$MYALIAS_SH"
  fi

  return 0
}

# ==============================================================================
# 加载自定义插件
# ==============================================================================
# 只操作可读但不可执行的、以*sh 为后缀名的文件
# ==============================================================================
function myPluginLoader ()
{
  local ZSHDIR="${HOME}/.zsh"
  local subdir=''
  local script=''
  # "alias" 和"path" 永远不应该被包含到这个数组
  local SCRIPTDIR=(
    'androidenv' 'apply' 'archpkg' 'iam' 'groot' 'less' 'logintmux' 'mountcmds'
    'profileutils' 'sshenv' 'vman'
  )

  for subdir in ${SCRIPTDIR[@]}
  do
    script="${ZSHDIR}/${subdir}"
    if [[ -d "$script" ]]
    then
      for script in "${script}"/*.sh
      do
        if [[ -r "$script" && ! -x "$script" ]]
        then
          source "$script"
        fi
      done
      unset 'script'
    fi
    unset 'subdir'
  done
}

{
  # From this file
  myPluginLoader
  myPathLoader
  myAliasLoader

  # From logintmux directory
  existcmd 'loginTmux' && loginTmux
  # From iam directory
  existcmd 'iam' && iam

  # Do some clear
  _uniqPath
  _uniqFpath
}

