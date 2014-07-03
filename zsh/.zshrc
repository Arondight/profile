# =========================
# zshrc 配置文件
# =========================
# 位置: ~/.zshrc
# 需要: oh-my-zsh, zsh-syntax-highlighting
#
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
if [[ "$ZSH" == "$HOME/.oh-my-zsh" ]]; then
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
# 保证各终端tmux 的一致性
# =========================
# X11 建议使用分屏式虚拟终端例如terminator
# 强烈建议在需要ssh 的机器上启用（例如你的VPS）
# =========================
#[[ -f /usr/bin/tmux ]] && test -z "$TMUX" && (TERM=xterm-256color tmux attach || tmux -2) && exit

# =========================
# 环境变量
# =========================
# 增加了一些特殊位置的bin 目录
# 增加了当前目录(但优先级最低)
PATH=$HOME/bin:/usr/local/bin:$PATH:.
[[ 0 -ne $(id -u) ]] && PATH=/root/bin:$PATH
# 额外的man 手册路径
MANPATH=/usr/local/man:$MANPATH
# 编译的架构参数
ARCHFLAGS='-arch x86_64'
# ssh key
SSH_KEY_PATH='~/.ssh/id_rsa'
# 默认编辑器
EDITOR="vim"
# 终端256 色
TERM="xterm-256color"
# LANG，使用DM 或者有了TTY 下UTF-8 解决方案需要注释掉if 语句块
#if [[ -z $DISPLAY ]]; then
#  LANG=en_US.UTF-8
#else
#  LANG=zh_CN.UTF-8
#fi

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
    sudo mount $1 $2 -o iocharset=utf8,umask=000
}
# ntfs 分区挂载
function mountntfs {
  if [[ -f /bin/ntfs-3g ]]; then
    sudo ntfs-3g $1 $2
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
  sudo mount -t auto,nontfs,nomsdos $1 $2 -o defaults
  sudo chown $(whoami):$(whoami) $2
}
# 卸载设备
function umountfs {
  sudo umount $1
}

# ========================
# alias
# ========================
# 文本处理 {
# less, more, diff, view, vi 全部使用vim
#alias less='sh /usr/share/vim/vim74/macros/less.sh'
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
alias cc='/usr/bin/gcc'
alias cc99='cc -std=gun99 -Wall'
alias cxx='/usr/bin/g++'
alias cxx11='cxx -std=c11 -Wall'
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
# pacman 自动高亮，提供升级、更新、清理指令
alias pacman='/usr/bin/pacman --color auto'
alias arch_update='sudo /usr/bin/pacman -Sy && [[ -f /usr/bin/pkgfile ]] && sudo /usr/bin/pkgfile -u'
alias arch_upgrade='sudo -i /usr/bin/pacman -Sy --needed --noconfirm linux-headers pkgfile && sudo /usr/bin/pacman -Su --noconfirm; sudo /usr/bin/pkgfile -u'
alias arch_clean='sudo /usr/bin/pacman -R --noconfirm $(/usr/bin/pacman -Qqdt); sudo /usr/bin/pacman -Sc --noconfirm'
alias arch_cleanall='sudo /usr/bin/pacman -R --noconfirm $(/usr/bin/pacman -Qqdt); sudo /usr/bin/pacman -Scc'
# startx 使用中文locale
alias startx='export LANG=zh_CN.UTF-8 && startx'
# 指令人性化输出
alias mkdir='/bin/mkdir -p -v'
alias df='/bin/df -h'
alias du='/bin/du -ch'
alias ping='/bin/ping -c 5'
# 快速关机、重启
alias poweroff='sudo /sbin/shutdown -h 0'
alias halt='poweroff'
alias reboot='sudo /sbin/shutdown -r 0'
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

