#!/usr/bin/env bash
# ==============================================================================
# 注册自定义插件
# ==============================================================================
# Created by Arondight <shell_way@foxmail.com>
# ==============================================================================
# 在shell 配置文件中加入下列一行:
#   source $HOME/.zsh/reactor.sh
# ==============================================================================

# ==============================================================================
# tmux
# ==============================================================================
# 适用于无法分屏的ssh 的环境
# ==============================================================================
# 保持各终端tmux 的一致性
function autosynctmux ()
{
  local SESSIONID='autotmux'

  if ! type tmux >/dev/null 2>&1
  then
    return 1
  fi

  if [[ -z "$TMUX" ]]
  then
    export TERM=xterm-256color
    if ! tmux attach
    then
      if tmux -2 new -s $SESSIONID
      then
        exit $?
      fi
    fi
  fi

  return $?
}
# 无视各终端tmux 的一致性
function autotmux ()
{
  if ! type tmux >/dev/null 2>&1
  then
    return 1
  fi

  if [[ -z "$TMUX" ]]
  then
    export TERM=xterm-256color
    if tmux -2 new
    then
      exit $?
    fi
  fi

  return $?
}
# 在虚拟化环境中尝试开各终端一致的tmux
# XXX: 这样做真的利大于弊？tmux 在移动设备上的表现并不好
if type systemd-detect-virt >/dev/null 2>&1
then
  if [[ 'none' != $(systemd-detect-virt) ]]
  then
    autosynctmux
  fi
fi

# ==============================================================================
# PATH
# ==============================================================================
MYPATHDIR="${HOME}/.zsh/path"
if [[ -d $MYPATHDIR ]]
then
  for script in ${MYPATHDIR}/*.sh
  do
    if [[ -r $script ]]
    then
      source $script
    fi
  done
  unset script
fi
# 当前目录必须*最后*添加
export PATH="${PATH}:."
# 对path 进行一次去重
if type perl >/dev/null 2>&1
then
  # XXX: 这里的去重考虑使用sed/awk 重写
  export PATH=$(
    perl -E 'print join ":", grep { ++$_{$_} < 2 } split ":", $ENV{PATH}'
  )
fi

# ==============================================================================
# alias
# ==============================================================================
MYALIAS_SH="${HOME}/.zsh/alias/alias.sh"
if [[ -r $MYALIAS_SH ]]
then
  source $MYALIAS_SH
fi

# ==============================================================================
# 加载自定义配置
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
    androidenv
    apply
    archpkg
    iam
    groot
    less
    mountcmds
    profileutils
    sshenv
    vman
  )

  for subdir in ${SCRIPTDIR[@]}
  do
    script="${ZSHDIR}/${subdir}"
    if [[ -d $script ]]
    then
      for script in ${script}/*.sh
      do
        if [[ -r $script && ! -x $script ]]
        then
          source $script
        fi
      done
      unset script
    fi
    unset subdir
  done
}

# 立刻装载一次
myPluginLoader

# 对fpath 进行一次去重
if type perl >/dev/null 2>&1
then
  # XXX: 考虑使用awk/sed 重写
  FPATH=$(
    echo -n $FPATH | perl -anF/:/ -E  \
      'print join ":", grep { ++$_{$_} < 2 } @F'
  )
fi

