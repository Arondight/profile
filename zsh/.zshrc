# =========================
# zshrc 配置文件
# =========================
# 位置: ~/.zshrc
#
#           By 秦凡东
# =========================

# =========================
# Say Hello ^_^
# =========================
if type fortune >/dev/null 2>&1; then
  if type cowsay >/dev/null 2>&1; then
    cowsay -f tux "$(fortune)"
  else
    fortune
  fi
else
  if type cowsay >/dev/null 2>&1; then
    cowsay -f tux "Hi $(whoami) ^_^"
  else
    echo "Hi $(whoami) ^_^"
  fi
fi

# =========================
# oh-my-zsh 路径
# =========================
# 优先使用~ 下的oh-my-zsh
# =========================
ZSH=/usr/share/oh-my-zsh
[[ -d $HOME/.oh-my-zsh ]] && ZSH=$HOME/.oh-my-zsh

# =========================
# PROMPT - 注释了一些不错的
# =========================
#ZSH_THEME='robbyrussell'
#ZSH_THEME='blinks'
#ZSH_THEME='dstufft'
ZSH_THEME='af-magic'
#ZSH_THEME='ys'
#ZSH_THEME='tjkirch'

# =========================
# oh-my-zsh 插件
# =========================
plugins=(
  battery colorize common-aliases dirhistory
  history-substring-search jump gnu-utils per-directory-history
  perl python sudo themes torrent textmate web-search
)
if [[ -w $ZSH ]]; then
  plugins+=zsh_reload
  [[ ! -d "$ZSH/cache" ]] && /bin/mkdir "$ZSH/cache"
fi
[[ -d $ZSH/plugins/zsh-completions ]] && plugins+=zsh-completions
[[ -d $ZSH/plugins/zsh-syntax-highlighting ]] && plugins+=zsh-syntax-highlighting
[[ -s /usr/bin/rsync ]] && plugins+=(cp rsync)
[[ -s /usr/bin/ruby ]] && plugins+=ruby
[[ -s /usr/bin/tmux ]] && plugins+=tmux
[[ -s /usr/bin/git ]] && plugins+=(git github git-prompt git-extras)
[[ -s /usr/bin/svn ]] && plugins+=(svn svn-fast-info)
[[ -s /usr/bin/gvim ]] && plugins+=vim-interaction
[[ -s /usr/bin/autojump ]] && plugins+=autojump
type pacman-key >/dev/null 2>&1 && plugins+=archlinux
type apt-get >/dev/null 2>&1 && plugins+=debian
type yum >/dev/null 2>&1 && plugins+=yum
type zypper >/dev/null 2>&1 && plugins+=suse
type systemctl >/dev/null 2>&1 && plugins+=systemd

# =========================
# autoload
# =========================
autoload -U colors && colors
autoload -U compinit && compinit
autoload -U promptinit promptinit

# =========================
# oh-my-zsh 自动更新
# =========================
# 关闭oh-my-zsh 自带的定期更新
# 当$ZSH 目录有写权限时提供更新指令
# =========================
DISABLE_AUTO_UPDATE="true"
function oh_my_zsh_upgrade {
  local current_path=$(pwd)

  if [[ -w "$ZSH/.git" ]]; then
    cd $ZSH/tools;
    zsh $ZSH/tools/upgrade.sh;
  fi

  cd $current_path
}

# ========================
# 其他oh-my-zsh 设置
# ========================
# 日期格式，合法间隔包括'/'、'.' 和'-'
HIST_STAMPS="yyyy-mm-dd"
# 大小写敏感？
CASE_SENSITIVE="false"
# 禁止自动设置终端标题？
DISABLE_AUTO_TITLE="false"
# 补全等待时显示红点？
COMPLETION_WAITING_DOTS="true"
# 允许自动改错？
ENABLE_CORRECTION="false"
# Disable marking untracked files under VCS as dirty ?
# This makes repository status check for large repositories faster.
DISABLE_UNTRACKED_FILES_DIRTY="false"

# =========================
# PATH
# =========================
# 脚本位于~/.zsh/path，后缀名为zsh
if [[ -d $HOME/.zsh/path ]]; then
  for script in $HOME/.zsh/path/*.zsh; do
    if [[ -r $script ]]; then
      source $script
    fi
  done
  unset script
fi
# 当前目录必须*最后*添加
path+=.
# 对path 进行一次去重
if type awk >/dev/null 2>&1; then
  path=( $(awk -vRS=' ' '!a[$1]++' <<< ${path[@]}) )
fi

# =========================
# 环境变量
# =========================
# 额外的man 手册路径
manpath+=/usr/local/man
# 对manpath 进行一次去重
if type awk >/dev/null 2>&1; then
  manpath=( $(awk -vRS=' ' '!a[$1]++' <<< ${manpath[@]}) )
fi
# 编译的架构参数
export ARCHFLAGS='-arch x86_64'
# ssh key
export SSH_KEY_PATH='~/.ssh/id_rsa'
# 默认编辑器
export EDITOR="/usr/bin/env vim"
# 终端256 色
export TERM="xterm-256color"
# python-virtualenvwrapper
export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3

# =========================
# 装载主题和插件
# =========================
if [[ -r $ZSH/oh-my-zsh.sh ]]; then
  source $ZSH/oh-my-zsh.sh
fi

# =========================
# 自动补全设置
# =========================
zstyle ':completion:*' verbose true
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# =========================
# tmux
# =========================
# 适用于无法分屏的ssh 的环境
# =========================
# 保持各终端tmux 的一致性
#[[ -f /usr/bin/tmux && -z "$TMUX" ]] && (TERM=xterm-256color && tmux attach || tmux -2) && exit
# =========================
# 无视各终端tmux 的一致性
#[[ -f /usr/bin/tmux && -z "$TMUX" ]] && (TERM=xterm-256color && tmux -2) && exit

# ========================
# alias
# ========================
if [[ -r $HOME/.zsh/alias/alias.zsh ]]; then
  source $HOME/.zsh/alias/alias.zsh
fi
if [[ -r $HOME/.zsh/alias/global_alias.zsh ]]; then
  source $HOME/.zsh/alias/global_alias.zsh
fi

# ========================
# 升级函数
# ========================
function profile_upgrade {
  local profile_root="$(dirname -z $(readlink -f $HOME/.zshrc))/.."
  local current_path="$(pwd)"

  cd $profile_root
  if [[ '-f' == $1 ]]; then
    git checkout -- .
  fi
  if git pull --rebase --stat https://github.com/Arondight/profile.git master; then
    echo "更新完成。"
  else
    cat <<EOF
更新失败，可能由于您在本地对配置做了修改。
你可以使用指令
  profile_upgrade -f
强制更新，但是会清除这些修改。
EOF
  fi

  cd $current_path

  return $?
}

# ========================
# 加载自定义配置
# ========================
# 位于~/.zsh
function load_local_script {
  zsh_path_root=$HOME/.zsh
  zsh_script_paths=(
    mount_function  # 挂载函数
    less            # less 函数
    archpkg         # archpkg 函数
    android_env     # android_env 函数
    #alias           # alias 永远不应该出现在这里
    #path            # path 永远不应该出现在这里
  )

  for subdirectory in ${zsh_script_paths[@]}; do
    script_path=$zsh_path_root/$subdirectory
    if [[ -d $script_path ]]; then
      for script in $script_path/*.zsh; do
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

