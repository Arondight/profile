#!/usr/bin/env bash
# ==============================================================================
# 注册自定义函数
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
      tmux -2 new -s $SESSIONID
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
    tmux -2 new
  fi

  return $?
}
# 在虚拟化环境中尝试开各终端一致的tmux
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
# 脚本位于~/.zsh/path，后缀名为sh
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
# 重新配置
# ==============================================================================
alias profile-reconf='profile_reconf'
function profile_reconf ()
{
  local PROFILEROOT=$(dirname $(dirname $(readlink -f $HOME/.zshrc)))
  local CWD=$(pwd)
  local INSTALL_SH="${PROFILEROOT}/install.sh"
  local ARGS='-a'

  cd $PROFILEROOT

  if [[ -x $INSTALL_SH ]]
  then
    command $INSTALL_SH $ARGS
  fi

  cd $CWD

  return $?
}

# ==============================================================================
# 升级函数
# ==============================================================================
alias profile-upgrade='profile_upgrade'
function profile_upgrade () {
  local PROFILEROOT=$(dirname $(dirname $(readlink -f $HOME/.zshrc)))
  local CWD=$(pwd)

  cd $PROFILEROOT
  if [[ '-f' == $1 ]]
  then
    git reset HEAD .
    git checkout -- .
  fi
  if git pull --rebase --stat https://github.com/Arondight/profile.git master
  then
    cat <<'EOF'
更新完成。
你可以需要运行以下指令来重新配置：
  profile-reconf
EOF
  else
    cat <<'EOF'
更新失败，可能由于您在本地对配置做了修改。
你可以使用-f 参数强制更新，但是会清除这些修改：
  profile-upgrade -f
EOF
  fi

  cd $CWD

  return $?
}

# ==============================================================================
# 加载自定义配置
# ==============================================================================
# 只操作可读但不可执行的、以*sh 为后缀名的文件
# ==============================================================================
function load_local_script ()
{
  local ZSHDIR="${HOME}/.zsh"
  local subdir=''
  local script=''

  SCRIPTDIR=(
    mount_function  # 分区快速挂载和批量卸载
    less            # 替代系统less
    archpkg         # slackpkg 风格的pacman 封装
    android_env     # 快速切换android 开发环境
    ssh_env         # 在ssh 密钥中快速切换
    groot           # 跳到git 仓库顶层目录
    vman            # 在Vim 中查看manual
    apply           # 补丁工具
    iam             # git 仓库user 信息配置
    # 以下两行永远不应该被包含
    #alias
    #path
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
load_local_script

# 对fpath 进行一次去重
if type perl >/dev/null 2>&1
then
  # XXX: 考虑使用awk/sed 重写
  FPATH=$(
    echo -n $FPATH | perl -anF/:/ -E  \
      'print join ":", grep { ++$_{$_} < 2 } @F'
  )
fi

