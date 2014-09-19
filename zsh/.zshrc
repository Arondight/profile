# =========================
# zshrc 配置文件
# =========================
# 位置: ~/.zshrc
#           By iSpeller
# =========================

# =========================
# Say Hello ^_^
# =========================
# 可选: cowsay, fortune
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
[[ -d "$HOME/.oh-my-zsh" ]] && ZSH=~/.oh-my-zsh

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
  autojump colorize common-aliases
  history-substring-search jump gnu-utils
  per-directory-history perl python themes textmate
)
if [[ -w $ZSH ]]; then
  plugins+=zsh_reload
  [[ ! -d "$ZSH/cache" ]] && /bin/mkdir "$ZSH/cache"
fi
[[ -f /usr/bin/rsync ]] && plugins+=(cp rsync)
[[ -f /usr/bin/ruby ]] && plugins+=ruby
[[ -f /usr/bin/tmux ]] && plugins+=tmux
[[ -f /usr/bin/git ]] && plugins+=(git github git-prompt)
[[ -f /usr/bin/gvim ]] && plugins+=vim-interaction
[[ -f /usr/bin/pacman ]] && plugins+=archlinux
# 如果已经alias 了apt-get 和systemctl
# 需要使用-f 指明明确路径测试是否存在
type apt-get >/dev/null 2>&1 && plugins+=debian
type systemctl >/dev/null 2>&1 && plugins+=systemd

# =========================
# 装载主题和插件
# =========================
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source $ZSH/oh-my-zsh.sh

# =========================
# oh-my-zsh 自动更新
# =========================
# 只对git clone 的oh-my-zsh
# 并且当$ZSH 目录有写权限时
# 才会每周进行一次自动更新
# =========================
DISABLE_AUTO_UPDATE="true"
UPDATE_ZSH_DAYS=7
[[ -w "$ZSH/.git" ]] && DISABLE_AUTO_UPDATE="false"

# ========================
# 其他oh-my-zsh 设置
# ========================
# 日期格式，合法间隔包括'/'、'.' 和'-'
HIST_STAMPS="yyyy-mm-dd"
# 大小写敏感
CASE_SENSITIVE="false"
# 禁止自动设置终端标题
DISABLE_AUTO_TITLE="false"
# 禁止指令自动纠错
DISABLE_CORRECTION="false"
# 补全等待时显示红点
COMPLETION_WAITING_DOTS="true"
# Disable marking untracked files under VCS as dirty.
# This makes repository status check for large repositories faster.
DISABLE_UNTRACKED_FILES_DIRTY="false"

# =========================
# zsh-syntax-higlighting
# =========================
# 优先使用~ 下的zsh-syntax-higlighting
# =========================
if [[ -d "/usr/share/zsh/plugins/zsh-syntax-highlighting" ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/*.zsh
elif [[ -d "$HOME/.zsh/plugins/zsh-syntax-highlighting" ]]; then
  source ~/.zsh/plugins/zsh-syntax-highlighting/*.zsh
elif [[ -d "$HOME/.zsh/zsh-syntax-highlighting" ]]; then
  source ~/.zsh/zsh-syntax-highlighting/*.zsh
elif [[ -d "$HOME/.zsh-syntax-highlighting" ]]; then
  source ~/.zsh-syntax-highlighting/*.zsh
fi

# =========================
# tmux
# =========================
# X11 建议使用分屏式虚拟终端例如terminator
# 强烈建议在需要ssh 的机器上启用（例如你的VPS）
# =========================
# 下面一行用于保持各种端tmux 的一致性，建议在远程主机上的私人账户上开启
#[[ -f /usr/bin/tmux && -z "$TMUX" ]] && (TERM=xterm-256color && tmux attach || tmux -2) && exit
# =========================
# 下面一行只启用tmux 但不保持各终端一致性，建议在远程主机的公共账户上开启
#[[ -f /usr/bin/tmux && -z "$TMUX" ]] && (TERM=xterm-256color && tmux -2) && exit

# =========================
# 环境变量
# =========================
# 增加了一些特殊位置的bin 目录
# 增加了当前目录(但优先级最低)
path=($HOME/bin /usr/local/bin $path .)
# 额外的man 手册路径
manpath=(/usr/local/man $manpath)
# 编译的架构参数
ARCHFLAGS='-arch x86_64'
# ssh key
SSH_KEY_PATH='~/.ssh/id_rsa'
# 默认编辑器
EDITOR="/usr/bin/vim"
# 终端256 色
TERM="xterm-256color"

# =========================
# 自动补全设置
# =========================
zstyle ':completion:*' verbose true
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# ========================
# 挂载函数
# ========================
# 需要: ntfs-3g
# ========================
# fat32 分区挂载
function mountfat {
    /usr/bin/sudo mount $1 $2 -o iocharset=utf8,umask=000
}
# ntfs 分区挂载
function mountntfs {
  if [[ -f /bin/ntfs-3g ]]; then
    /usr/bin/sudo ntfs-3g $1 $2
  else
    mountfat $1 $2
  fi
}
# iso 文件挂载
function mountiso {
  mount $1 $2 -o loop
}
# 其他分区挂载
function mountfs {
  /usr/bin/sudo mount -t nontfs,nomsdos $1 $2 -o defaults
  /usr/bin/sudo chown $(whoami):$(whoami) $2
}
# 卸载设备
function umountfs {
  /usr/bin/sudo umount $1
}

# ========================
# less 函数
# ========================
function less {
  local file_src=''
  local less_program=''

  if [[ -x /usr/bin/vim ]]; then
    less_program="/usr/bin/vim -c 'set nofoldenable' \
                                -c 'let no_plugin_maps = 1' \
                                -c 'runtime! macros/less.vim' "
  elif [[ -x /usr/bin/nano ]]; then
    less_program='/usr/bin/nano -v '
  else
    exec /usr/bin/less $@
  fi

  if [[ 0 == $# ]]; then
    file_src='-'
    if [[ -t 0 ]]; then
      echo "Missing filename" >&2
      return 1
    fi
  else
    file_src='$@'
  fi

  if [[ ! -t 1 ]]; then
    exec /usr/bin/cat $@
  fi

  eval $less_program $file_src
}

# ========================
# archpkg 函数
# 提供slackpkg 风格的包管理
# 纯自用，因为有点小恋旧癖
# ========================
function archpkg {
  if [[ 0 == $# ]]; then
    set -- "help"
  fi

  while true; do
    case "$1" in
      update)
        shift
        /usr/bin/sudo /usr/bin/pacman -Sy
        if [[ -f /usr/bin/pkgfile ]]; then
          /usr/bin/pkgfile --update
        fi
        ;;
      check-updates)
        shift
        /usr/bin/sudo /usr/bin/pacman -Qu $@
        return $?
        ;;
      upgrade-all)
        /usr/bin/sudo /usr/bin/pacman --needed --noconfirm --color auto -Sy linux-headers
        /usr/bin/sudo /usr/bin/pacman --noconfirm --color auto -Su
        if [[ -f /usr/bin/pkgfile ]]; then
          /usr/bin/pkgfile --update
        fi
        shift
        ;;
      clean-system)
        local result
        shift
        result=( $(pacman -Qqdt) )
        if [[ '' != $result ]]; then
          /usr/bin/sudo /usr/bin/pacman --noconfirm --color auto -R $result
        fi
        /usr/bin/sudo /usr/bin/pacman --noconfirm --color auto -Sc
        ;;
      install)
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        /usr/bin/sudo /usr/bin/pacman --needed --color auto -S $@
        return $?
        ;;
       reinstall)
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        /usr/bin/sudo /usr/bin/pacman --color auto -S $@
        return $?
        ;;
      remove)
        local result
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        result=( $(/usr/bin/pacman -Qqs $1) )
        if [[ '' != $result ]]; then
          /usr/bin/sudo /usr/bin/pacman --color auto -Rsn $result
        fi
        return $?
        ;;
      download)
        shift;
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        /usr/bin/sudo /usr/bin/pacman --color auto -Sw $@
        return $?
        ;;
      info)
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        /usr/bin/pacman --color auto -Si $@
        return $?
        ;;
      search)
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        /usr/bin/pacman --color auto -Ss $@
        return $?
        ;;
      file-search)
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        if [[ ! -f /usr/bin/pkgfile ]]; then
          /usr/bin/sudo /usr/bin/pacman --noconfirm --color auto -S pkgfile
          /usr/bin/pkgfile --update
        fi
        /usr/bin/pkgfile --search $@
        return $?
        ;;
      generate-template)
        local template_file
        local list_of_packages
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        template_file=$(readlink -f $1)
        template_file="$template_file.template"
        /usr/bin/sudo -v
        echo "生成软件包列表（需要一会儿）"
        list_of_packages=$(/usr/bin/pacman -Qqn)
        echo "生成$template_file"
        echo $list_of_packages | /usr/bin/sudo /usr/bin/tee -a $template_file >/dev/null 2>&1
        ;;
      install-template)
        local template_file
        local list_of_packages
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        template_file=$(readlink -f $1)
        template_file="$template_file.template"
        if [[ ! -e $template_file ]]; then
          echo "文件$template_file 不存在。"
          return 1
        fi
        list_of_packages=( $(/usr/bin/cat $template_file) )
        /usr/bin/sudo /usr/bin/pacman --needed --color auto -S $list_of_packages
        ;;
      remove-template)
        local template_file
        local list_of_packages
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        template_file=$(readlink -f $1)
        template_file="$template_file.template"
        if [[ ! -e $template_file ]]; then
          echo "文件$template_file 不存在。"
          return 1
        fi
        list_of_packages=( $(/usr/bin/cat $template_file) )
        /usr/bin/sudo /usr/bin/pacman --color auto -Rsn $list_of_packages
        ;;
      h|help|-h|--help)
        /usr/bin/cat << END_OF_HELP
archpkg 提供了slackpkg 风格的软件包管理机制

用法:
  archpkg [选项] <匹配串|文件名>

选项:
  help                          显示本帮助
  update                        更新软件仓库
  check-updates [包名]          检查更新
  upgrade-all                   更新系统
  clean-system                  清理旧的软件包缓存
  install <包名>                安装软件包
  reinstall <包名>              重新安装软件包
  remove <正则表达式>           卸载软件包
  download <包名>               下载软件包但不安装
  info <包名>                   打印软件包信息
  search <正则表达式>           查找软件包
  file-search <文件名>          显示某文件属于哪个包
  generate-template <模板名>    生成包含软件包列表的模板文件
  install-template <模板名>     安装模板文件中记录的所有软件包
  remove-template <模板名>      删除模板文件中记录的所有软件包(永远不要使用!)

示例:
  archpkg upgrade-all clean-system
  archpkg file-search vim
  archpkg remove lib32-.+
END_OF_HELP
      return 1
      ;;
    *)
      echo "使用archpkg -h 查看帮助"
      return 1
    esac
  done
}

# ========================
# alias
# ========================
# 文本处理 {
# less, more, diff, view, vi 全部使用vim
# less 函数请查看之前的定义
alias more='less'
alias diff='/usr/bin/vim -d'
alias view='/usr/bin/vim -R'
alias vi='/usr/bin/vim'
# grep 自动高亮，默认使用pcre 正则
alias grep='/bin/grep --color=auto -P'
alias egrep='/bin/grep --color=auto -E'
# 防止别处nano 的alisa 影响了nano 配置文件(nano 参数优先)
alias nano='/usr/bin/nano'
# leafpad 默认使用utf8 编码
alias leafpad='/usr/bin/leafpad --codeset=utf8'
# }
# cc {
# 提供cc99, cxx11 等编译小程序的指令
alias gcc='/usr/bin/gcc -Wall -fdiagnostics-color=auto'
alias cc='gcc'
alias c99='cc -std=gnu99'
alias g++='/usr/bin/g++ -Wall -fdiagnostics-color=auto'
alias cxx='g++'
alias cxx11='cxx -std=gnu++11'
# }
# ls {
# ls 自动高亮，显示后缀，易于阅读格式
# 提供了ls 指令缩写并和vim 搭配
alias ls='/bin/ls -hF --color=auto'
alias dir='ls'
alias d='ls'
alias dm='d | more'
alias a='ls -A'
alias am='a | more'
alias v='d -lh'
alias vm='v | more'
alias l='v -A'
alias lm='l | more'
# 快捷cd：.bashrc 的遗留物，oh-my-zsh 内置
alias ..='cd ..'
alias ....='../..'
alias cd..='..'
alias cd....='....'
alias ~='cd ~'
alias /='cd /'
alias cd/='/'
# }
# 安全措施{
# cp, mv, rm, ln 询问确认
# 不希望确认请使用绝对路径
alias cp='/bin/cp -i'
alias mv='/bin/mv -i'
alias rm='/bin/rm -I'
alias ln='/bin/ln -i'
# 危险性指令禁止处理根目录
alias chown='/bin/chown --preserve-root'
alias chmod='/bin/chmod --preserve-root'
alias chgrp='/bin/chgrp --preserve-root'
# }
# 常用系统指令 {
alias pacman='/usr/bin/pacman --color auto'
# startx 使用中文locale
alias startx='export LANG=zh_CN.UTF-8 && startx'
# 指令人性化输出
alias mkdir='/bin/mkdir -p -v'
alias df='/bin/df -h'
alias du='/bin/du -ch'
alias ping='/bin/ping -c 5'
# 快速关机、重启
alias poweroff='/usr/bin/sudo /sbin/shutdown -h 0'
alias halt='poweroff'
alias reboot='/usr/bin/sudo /sbin/shutdown -r 0'
# x11nvc 启动vncserver
alias vnc-start='/usr/bin/x11vnc -display :0 -noxdamage -many -forever -ncache 10 -auth ~/.Xauthority -rfbauth ~/.vnc/passwd'
# }
# 其他 {
# }
# 系统嗲用查询
alias grepsyscall_32='/bin/cat /usr/include/asm/unistd_32.h | grep -P '
alias grepsyscall_64='/bin/cat /usr/include/asm/unistd_64.h | grep -P '
# vim 式退出当前登录
alias quit='exit'
alias q='quit'
alias :q='q'
alias :wq='q'
alias :Q='q'
alias :x='q'
# }

