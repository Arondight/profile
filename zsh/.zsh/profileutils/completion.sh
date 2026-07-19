#!/usr/bin/env cat
# shellcheck shell=bash
# ==============================================================================
# profileutils 补全（zsh + bash 通用）
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================
# 本文件由 loader.sh 自动 source，为 profileupdate 及其别名提供补全。
# profilereconf 不接受参数，无需补全。
# ==============================================================================

# ==============================================================================
# 补全函数定义
# ==============================================================================
# zsh 端
function _profile_profileupdate ()
{
  _arguments \
    '(-f --force)'{-f,--force}'[Force update, discarding local changes]'
}

# bash 端
function _profile_profileupdate_bash ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W '-f --force' -- "$cur"))
  return 0
}

# ==============================================================================
# 注册（按 shell 区分）
# ==============================================================================
if [[ -n "$ZSH_NAME" ]]
then
  compdef _profile_profileupdate profileupdate profile-update profile_update
else
  complete -F _profile_profileupdate_bash profileupdate profile-update profile_update
fi
