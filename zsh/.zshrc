# ==============================================================================
# zsh 配置文件
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# 位置: ~/.zshrc
# ==============================================================================

# ==============================================================================
# If a command exist
# ==============================================================================
function existcmd ()
{
  local cmd="$1"
  type "$cmd" >/dev/null 2>&1
  return $?
}

# ==============================================================================
# 配置oh-my-zsh
# ==============================================================================
function oh_my_zsh_conf ()
{
  # ==============================================================================
  # PROMPT - 注释了一些不错的
  # ==============================================================================
  #ZSH_THEME='af-magic'
  #ZSH_THEME='robbyrussell'
  #ZSH_THEME='tjkirch'
  ZSH_THEME='ys'

  # ==============================================================================
  # oh-my-zsh 插件
  # ==============================================================================
  # 官方通用插件
  plugins=(
    'battery' 'colorize' 'command-not-found' 'common-aliases' 'copypath'
    'copyfile' 'dircycle' 'dirhistory' 'dirpersist' 'encode64' 'gnu-utils'
    'history-substring-search' 'jump' 'pass' 'per-directory-history' 'perl'
    'systemadmin' 'textmate' 'themes' 'torrent' 'urltools' 'wd' 'web-search'
    'zsh-navigation-tools'
  )
  # 选择性加载
  existcmd 'adb' && plugins+=('adb' 'repo')
  existcmd 'apt-get' && plugins+='debian'
  existcmd 'autojump' && plugins+='autojump'
  existcmd 'dnf' && plugins+='dnf'
  existcmd 'docker' && plugins+='docker'
  existcmd 'emacs' && plugins+='emacs'
  existcmd 'fbterm' && plugins+='fbterm'
  existcmd 'firewalld' && plugins+='firewalld'
  existcmd 'git' && plugins+=('git' 'github' 'git-prompt' 'git-extras')
  existcmd 'go' && plugins+=('golang')
  existcmd 'gvim' && plugins+='vim-interaction'
  existcmd 'nmap' && plugins+='nmap'
  existcmd 'node' && plugins+='node'
  existcmd 'npm' && plugins+='npm'
  existcmd 'pacman-key' && plugins+='archlinux'
  existcmd 'pip' && plugins+='pip'
  existcmd 'pylint' && plugins+='pylint'
  existcmd 'python' && plugins+='python'
  existcmd 'rsync' && plugins+=('cp' 'rsync')
  existcmd 'ruby' && plugins+=('ruby' 'rails')
  existcmd 'rust' && plugins+='rust'
  existcmd 'rvm' && plugins+='rvm'
  existcmd 'screen' && plugins+='screen'
  #existcmd 'ssh-agent' && plugins+='ssh-agent'
  existcmd 'sublime' && plugins+='sublime'
  existcmd 'sudo' && plugins+='sudo'
  existcmd 'svn' && plugins+=('svn' 'svn-fast-info')
  existcmd 'systemctl' && plugins+='systemd'
  existcmd 'tmux' && plugins+='tmux'
  #existcmd 'whois' && plugins+='iwhois'
  existcmd 'yum' && plugins+='yum'
  existcmd 'zypper' && plugins+='suse'
  # 第三方插件
  customPlugins=(
    'zsh-autosuggestions'
    'zsh-completions'
    'zsh-syntax-highlighting'
  )
  allCustomPlugins=(
    $(find ${ZSH}/custom/plugins/* -maxdepth 0 -type d | xargs -I {} basename {})
  )
  plugins+=(
    $(echo "${customPlugins[@]}" "${allCustomPlugins[@]}" |\
      tr '[:space:]' "\n" | sort | uniq -d)
  )

  # ==============================================================================
  # oh-my-zsh 自动更新
  # ==============================================================================
  # 关闭oh-my-zsh 自带的定期更新，当$ZSH 目录有写权限时提供更新指令
  DISABLE_AUTO_UPDATE="true"
  alias oh-my-zsh-upgrade='oh_my_zsh_upgrade'
  function oh_my_zsh_upgrade
  {
    if [[ -w "${ZSH}/.git" ]]
    then
      pushd "${ZSH}/tools"
      command "${ZSH}/tools/upgrade.sh"
      popd
    fi
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
}

# ==============================================================================
# Say Hello ^_^
# ==============================================================================
if existcmd 'fortune'
then
  if existcmd 'cowsay'
  then
    cowsay -f tux "$(fortune)"
  else
    fortune
  fi
else
  if existcmd 'cowsay'
  then
    cowsay -f tux "Hi $(whoami) ^_^"
  else
    echo "Hi $(whoami) ^_^"
  fi
fi

# ==============================================================================
# oh-my-zsh 路径
# ==============================================================================
LOAD_OH_MY_ZSH=1
if [[ -d "${HOME}/.oh-my-zsh" ]]
then
  ZSH="${HOME}/.oh-my-zsh"
elif [[ -d '/usr/share/oh-my-zsh' ]]
then
  ZSH='/usr/share/oh-my-zsh'
  ZSH_CACHE_DIR="${HOME}/.oh-my-zsh-cache"
  mkdir -p "$ZSH_CACHE_DIR"
else
  LOAD_OH_MY_ZSH=0
fi

# ==============================================================================
# 装载主题和插件
# ==============================================================================
if [[ 1 -eq "$LOAD_OH_MY_ZSH" && -r "${ZSH}/oh-my-zsh.sh" ]]
then
  oh_my_zsh_conf && source "${ZSH}/oh-my-zsh.sh"
fi

# ==============================================================================
# 模块导入
# ==============================================================================
zmodload 'zsh/mathfunc'

# ==============================================================================
# 环境变量
# ==============================================================================
# 额外的man 手册路径
if [[ ${#manpath[@]} -gt 0 ]]
then
  manpath+=('/usr/share/man' '/usr/local/share/man')
fi
# 对manpath 进行一次去重
if existcmd 'awk'
then
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
# For gpg2
export GPG_TTY="$TTY"

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
if [[ -r "${HOME}/.zsh_history" ]]
then
  fc -R "${HOME}/.zsh_history"
fi

# ==============================================================================
# 自定义配置
# ==============================================================================
if [[ -r "${HOME}/.zsh/reactor.sh" ]]
then
  source "${HOME}/.zsh/reactor.sh"
fi

# ==============================================================================
# 和expr 类似的计算器
# ==============================================================================
zle -N exprline
bindkey "^[e" exprline
function exprline ()
{
  if [[ ! -z "$BUFFER" ]]
  then
    BUFFER="echo \$(($BUFFER))"
  fi

  zle 'end-of-line'
}

# ==============================================================================
# 绝对秒数化为可读时间
# ==============================================================================
function timeconv {
  date -d "@${1}" +"%Y-%m-%d %T"
}

# ==============================================================================
# autoload
# ==============================================================================
autoload -U colors && colors
autoload -U compinit && compinit
autoload -U promptinit promptinit

