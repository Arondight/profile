#!/usr/bin/env zsh
# ======================== #
# alias                    #
#                          #
#             By 秦凡东    #
# ======================== #

# 文本处理 {
alias a='/usr/bin/env awk'
alias c='/usr/bin/env cat'
# less, more, diff, view, vi 全部使用vim
alias more='less'
alias m='more'
alias diff='/usr/bin/env vim -d'
alias sysdiff='/usr/bin/env diff'
alias view='/usr/bin/env vim -R'
alias vi='/usr/bin/env vim'
# grep 自动高亮，默认使用pcre 正则
alias grep='/usr/bin/env grep --color=auto -P'
alias egrep='/usr/bin/env grep --color=auto -E'
# 防止别处nano 的alisa 影响了nano 配置文件
alias nano='/usr/bin/env nano'
# leafpad 默认使用utf8 编码
alias leafpad='/usr/bin/env leafpad --codeset=utf8'
# }
# cc {
# 提供cc99, cxx11 等编译小程序的指令
alias c99='/usr/bin/env gcc -Wall -std=c99 -fdiagnostics-color=auto'
alias cxx11='/usr/bin/env g++ -Wall -std=c++11 -fdiagnostics-color=auto'
# }
# ls {
alias ls='/usr/bin/env ls -hF --color=auto'
alias dir='ls'
alias d='ls'
alias dm='d | m'
alias a='ls -A'
alias am='a | m'
alias v='d -lh'
alias vm='v | m'
alias l='v -A'
alias lm='l | m'
# }
# cd {
alias ~='cd ~'
alias /='cd /'
alias cd/='/'
# }
# 安全措施{
alias cp='/usr/bin/env cp -i'
alias mv='/usr/bin/env mv -i'
alias rm='/usr/bin/env rm -I --preserve-root'
alias ln='/usr/bin/env ln -i'
alias chown='/usr/bin/env chown --preserve-root'
alias own='chown'
alias chmod='/usr/bin/env chmod --preserve-root'
alias mod='chmod'
alias chgrp='/usr/bin/env chgrp --preserve-root'
alias grp='chgrp'
# }
# 常用指令 {
alias e='export'
alias f='/usr/bin/env free'
alias k='kill'
alias p='/usr/bin/env perl'
alias r='/usr/bin/env ruby'
alias s='/usr/bin/env svn'
alias x='/usr/bin/env startx'
# 包管理
if [[ -s /usr/bin/pacman-key ]]; then
  alias pacman='/usr/bin/env pacman --color auto'
fi
# startx 使用中文locale
alias startx='export LANG=zh_CN.UTF-8 && /usr/bin/env startx'
# 指令人性化输出
alias mkdir='/usr/bin/env mkdir -p -v'
alias df='/usr/bin/env df -h'
alias du='/usr/bin/env du -ch'
alias ping='/usr/bin/env ping -c 5'
# 快速关机、重启
alias poweroff='/usr/bin/env sudo /usr/bin/env shutdown -h 0'
alias halt='poweroff'
alias reboot='/usr/bin/env sudo /usr/bin/env shutdown -r 0'
# x11nvc 启动vncserver
alias vnc-start='/usr/bin/env x11vnc -display :0 -noxdamage -many -forever -ncache 10 -auth ~/.Xauthority -rfbauth ~/.vnc/passwd'
# }
# 其他 {
# }
alias grepsyscall_32='/usr/bin/env cat /usr/include/asm/unistd_32.h | grep '
alias grepsyscall_64='/usr/bin/env cat /usr/include/asm/unistd_64.h | grep '
# vim 式退出登录
alias quit='exit'
alias q='quit'
alias :q='q'
alias :wq='q'
alias :Q='q'
alias :x='q'
# }

