#!/usr/bin/env cat
# shellcheck shell=bash
# ==============================================================================
# vimman 补全（zsh + bash 通用）
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================
# 本文件由 loader.sh 自动 source，为 vimman 提供 tab 补全。
# 补全包括手册章节号（1-9）与手册页名称。
# ==============================================================================

# ==============================================================================
# 补全函数定义
# ==============================================================================
# zsh 端
function _profile_vimman ()
{
  if [[ $CURRENT -gt 1 ]]
  then
    local _prev="$words[$((CURRENT-1))]"
    if [[ $_prev == [1-9] ]]
    then
      _man "$_prev"
      return
    fi
  fi
  _values 'vimman' \
    '1[User commands]' \
    '2[System calls]' \
    '3[Library functions]' \
    '4[Special files]' \
    '5[File formats]' \
    '6[Games]' \
    '7[Miscellaneous]' \
    '8[Administration]' \
    '9[Kernel]'
  _man
}

# bash 端
function _profile_vimman_bash ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"
  local sections='1 2 3 4 5 6 7 8 9'
  local manpages=''
  if existcmd 'apropos'
  then
    manpages=$(apropos '' 2>/dev/null | awk '{print $1}' | sort -u)
  fi
  if [[ $COMP_CWORD -ge 2 && "$prev" =~ ^[1-9]$ ]]
  then
    COMPREPLY=($(compgen -W "$manpages" -- "$cur"))
  else
    COMPREPLY=($(compgen -W "$sections $manpages" -- "$cur"))
  fi
  return 0
}

# ==============================================================================
# 注册（按 shell 区分）
# ==============================================================================
if [[ -n "$ZSH_NAME" ]]
then
  compdef _profile_vimman vimman
else
  complete -F _profile_vimman_bash vimman
fi
