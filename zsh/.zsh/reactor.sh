#!/usr/bin/env bash
# ==============================================================================
# 注册自定义函数
# ==============================================================================
# 在shell 配置文件中加入下列一行:
#   source $HOME/.zsh/reactor.sh
#
#           By 秦凡东
# ==============================================================================

# ==============================================================================
# tmux
# ==============================================================================
# 适用于无法分屏的ssh 的环境
# ==============================================================================
# 保持各终端tmux 的一致性
#[[ -f /usr/bin/tmux && -z "$TMUX" ]] && (TERM=xterm-256color && tmux attach || tmux -2) && exit
# ==============================================================================
# 无视各终端tmux 的一致性
#[[ -f /usr/bin/tmux && -z "$TMUX" ]] && (TERM=xterm-256color && tmux -2) && exit

# ==============================================================================
# PATH
# ==============================================================================
# 脚本位于~/.zsh/path，后缀名为sh
if [[ -d $HOME/.zsh/path ]]; then
  for script in $HOME/.zsh/path/*.sh; do
    if [[ -r $script ]]; then
      source $script
    fi
  done
  unset script
fi
# 当前目录必须*最后*添加
export PATH=$PATH:.
# 对path 进行一次去重
if type perl >/dev/null 2>&1; then
  export PATH=$(
    perl -E 'print join ":", grep { ++$_{$_} < 2 } split ":", $ENV{PATH}'
  )
fi

# ==============================================================================
# alias
# ==============================================================================
if [[ -r $HOME/.zsh/alias/alias.sh ]]; then
  source $HOME/.zsh/alias/alias.sh
fi

# ==============================================================================
# 升级函数
# ==============================================================================
alias profile-upgrade='profile_upgrade'
function profile_upgrade {
  local profile_root="$(dirname -z $(readlink -f $HOME/.zshrc))/.."
  local current_path="$(pwd)"

  cd $profile_root
  if [[ '-f' == $1 ]]; then
    git checkout -- .
  fi
  if git pull --rebase --stat https://github.com/Arondight/profile.git master; then
    cat <<'EOF'
更新完成。
你可能需要手动安装新的Vim 插件：
  vim -c PluginInstall -c qa
EOF
  else
    cat <<'EOF'
更新失败，可能由于您在本地对配置做了修改。
你可以使用-f 参数强制更新，但是会清除这些修改：
  profile_upgrade -f
EOF
  fi

  cd $current_path

  return $?
}

# ==============================================================================
# 加载自定义配置
# ==============================================================================
# 位于~/.zsh
# ==============================================================================
function load_local_script {
  zsh_path_root=$HOME/.zsh
  zsh_script_paths=(
    mount_function  # 分区快速挂载和批量卸载
    less            # 替代系统less
    archpkg         # slackpkg 风格的pacman 封装
    android_env     # 快速切换android 开发环境
    ssh_env         # 在ssh 密钥中快速切换
    groot           # 跳到git 仓库顶层目录
    vman            # 在Vim 中查看manual
    # 以下两行永远不应该被包含
    #alias
    #path
  )

  for subdirectory in ${zsh_script_paths[@]}; do
    script_path=$zsh_path_root/$subdirectory
    if [[ -d $script_path ]]; then
      for script in $script_path/*.sh; do
        if [[ -r $script ]]; then
          source $script
        fi
      done
      unset script
    fi
    unset script_path
  done
}
# 立刻装载一次
load_local_script

# 对fpath 进行一次去重
if type perl >/dev/null 2>&1; then
  FPATH=$(
    echo -n $FPATH | perl -anF/:/ -E  \
      'print join ":", grep { ++$_{$_} < 2 } @F'
  )
fi

