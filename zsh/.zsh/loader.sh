#!/usr/bin/env bash
# ==============================================================================
# 注册自定义插件
# ==============================================================================
# Created by Arondight <shell_way@foxmail.com>
# ==============================================================================
# 在shell 配置文件中加入下列一行:
#   source $HOME/.zsh/loader.sh
# ==============================================================================

if ! type existcmd >/dev/null 2>&1
then
  function existcmd ()
  {
    local cmd="$1"
    type "$cmd" >/dev/null 2>&1
    return "$?"
  }
fi

# ==============================================================================
# 对path 进行去重
# ==============================================================================
function _uniqPath ()
{
  local _new_path
  _new_path="$(echo "$PATH" | awk -F: '{
    for (i = 1; i <= NF; i++)
      if (!seen[$i]++)
        printf "%s%s", (i > 1 ? ":" : ""), $i
    print ""
  }')"
  if [[ -n "$_new_path" ]]
  then
    export PATH="$_new_path"
  fi

  return 0
}

# ==============================================================================
# 对fpath 进行去重
# ==============================================================================
function _uniqFpath ()
{
  local _new_fpath
  _new_fpath="$(echo "$FPATH" | awk -F: '{
    for (i = 1; i <= NF; i++)
      if (!seen[$i]++)
        printf "%s%s", (i > 1 ? ":" : ""), $i
    print ""
  }')"
  if [[ -n "$_new_fpath" ]]
  then
    export FPATH="$_new_fpath"
  fi

  return 0
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
        # shellcheck disable=SC1090
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
  local _ret=0

  if [[ -r "$MYALIAS_SH" ]]
  then
    # shellcheck disable=SC1090
    source "$MYALIAS_SH"
    _ret="$?"
  fi

  return "$_ret"
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
    'archpkg' 'custom' 'ipmi' 'groot' 'vimless' 'logintmux' 'mountcmds'
    'profileutils' 'sshenv' 'vimman'
  )

  for subdir in "${SCRIPTDIR[@]}"
  do
    script="${ZSHDIR}/${subdir}"
    if [[ -d "$script" ]]
    then
      for script in "${script}"/*.sh
      do
        if [[ -r "$script" && ! -x "$script" ]]
        then
          # shellcheck disable=SC1090
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
  #existcmd 'loginTmux' && loginTmux
  # From iam directory
  #existcmd 'iam' && iam
  # From custom directory, this SHOULD be last
  existcmd 'customShellrc' && customShellrc

  # Do some clear
  _uniqPath
  _uniqFpath
}

