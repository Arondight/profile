# ==============================================================================
# zsh 配置文件
# ==============================================================================
# 位置: ~/.zshrc
#
#           By 秦凡东
# ==============================================================================

# ==============================================================================
# Say Hello ^_^
# ==============================================================================
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

# ==============================================================================
# oh-my-zsh 路径
# ==============================================================================
# 优先使用~ 下的oh-my-zsh
# ==============================================================================
ZSH=/usr/share/oh-my-zsh
[[ -d $HOME/.oh-my-zsh ]] && ZSH=$HOME/.oh-my-zsh

# ==============================================================================
# PROMPT - 注释了一些不错的
# ==============================================================================
#ZSH_THEME='robbyrussell'
#ZSH_THEME='blinks'
#ZSH_THEME='dstufft'
ZSH_THEME='af-magic'
#ZSH_THEME='ys'
#ZSH_THEME='tjkirch'

# ==============================================================================
# oh-my-zsh 插件
# ==============================================================================
plugins=(
  battery colorize common-aliases dirhistory
  history-substring-search jump gnu-utils per-directory-history
  perl python sudo themes torrent textmate web-search
  zsh-completions zsh-syntax-highlighting
)
if [[ -w $ZSH ]]; then
  plugins+=zsh_reload
  [[ ! -d "$ZSH/cache" ]] && env mkdir "$ZSH/cache"
fi
[[ -s /usr/bin/rsync ]] && plugins+=(cp rsync)
[[ -s /usr/bin/ruby ]] && plugins+=ruby
[[ -s /usr/bin/tmux ]] && plugins+=tmux
[[ -s /usr/bin/git ]] && plugins+=(git github git-prompt git-extras)
[[ -s /usr/bin/svn ]] && plugins+=(svn svn-fast-info)
[[ -s /usr/bin/gvim ]] && plugins+=vim-interaction
[[ -s /usr/bin/autojump ]] && plugins+=autojump
type adb >/dev/null 2>&1 && plugins+=adb
type pacman-key >/dev/null 2>&1 && plugins+=archlinux
type apt-get >/dev/null 2>&1 && plugins+=debian
type yum >/dev/null 2>&1 && plugins+=yum
type zypper >/dev/null 2>&1 && plugins+=suse
type systemctl >/dev/null 2>&1 && plugins+=systemd

# ==============================================================================
# oh-my-zsh 自动更新
# ==============================================================================
# 关闭oh-my-zsh 自带的定期更新
# 当$ZSH 目录有写权限时提供更新指令
# ==============================================================================
DISABLE_AUTO_UPDATE="true"
alias oh-my-zsh-upgrade='oh_my_zsh_upgrade'
function oh_my_zsh_upgrade {
  local current_path=$(pwd)

  if [[ -w "$ZSH/.git" ]]; then
    cd $ZSH/tools;
    zsh $ZSH/tools/upgrade.sh;
  fi

  cd $current_path
}

# ==============================================================================
# 其他设置
# ==============================================================================
# 合法单词字符
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
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

# ==============================================================================
# 装载主题和插件
# ==============================================================================
if [[ -r $ZSH/oh-my-zsh.sh ]]; then
  source $ZSH/oh-my-zsh.sh
fi

# ==============================================================================
# 模块导入
# ==============================================================================
zmodload zsh/mathfunc

# ==============================================================================
# 环境变量
# ==============================================================================
# 额外的man 手册路径
manpath+=/usr/local/man
# 对manpath 进行一次去重
if type awk >/dev/null 2>&1; then
  manpath=( $(awk -vRS=' ' '!a[$1]++' <<< ${manpath[@]}) )
fi
# 编译的架构参数
export ARCHFLAGS='-arch x86_64'
# ssh key
export SSH_KEY_PATH="$HOME/.ssh/id_rsa"
# 默认编辑器
export EDITOR="env vim"
# 终端256 色
export TERM="xterm-256color"
# python-virtualenvwrapper
export WORKON_HOME="$HOME/.virtualenvs"
export VIRTUALENVWRAPPER_PYTHON="$(which python)"

# ==============================================================================
# 自动补全设置
# ==============================================================================
zstyle ':completion:*' verbose true
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# ==============================================================================
# 历史记录
# ==============================================================================
if [[ -r $HOME/.zsh_history ]]; then
  fc -R $HOME/.zsh_history
fi

# ==============================================================================
# 自定义配置
# ==============================================================================
if [[ -r $HOME/.zsh/reactor.sh ]]; then
  source $HOME/.zsh/reactor.sh
fi

# ==============================================================================
# 指令前插入sudo
# ==============================================================================
zle -N sudoline
bindkey "\e\e" sudoline
function sudoline {
  if [[ -z $BUFFER ]]; then
    zle up-history
  fi

  if [[ $BUFFER != sudo\ * ]]; then
    BUFFER="sudo $BUFFER"
  fi

  zle end-of-line
}

# ==============================================================================
# 和expr 类似的计算器
# ==============================================================================
zle -N exprline
bindkey "^e" exprline
function exprline {
  if [[ ! -z $BUFFER ]]; then
    BUFFER="echo \$(($BUFFER))"
  fi

  zle end-of-line
}

# ==============================================================================
# 绝对秒数化为可读时间
# ==============================================================================
function timeconv {
  date -d @$1 +"%Y-%m-%d %T"
}

# ==============================================================================
# autoload
# ==============================================================================
autoload -U colors && colors
autoload -U compinit && compinit
autoload -U promptinit promptinit

