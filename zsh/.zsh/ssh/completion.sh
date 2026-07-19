#!/usr/bin/env cat
# shellcheck shell=bash
# ==============================================================================
# ssh 补全（zsh + bash 通用）
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================
# 本文件由 loader.sh 自动 source，为 ssh_forget 及其别名 ssh-forget
# 提供 tab 补全（补全 known_hosts 的行号）。
# ==============================================================================

# ==============================================================================
# 补全函数定义
# ==============================================================================
# zsh 端
function _profile_ssh_forget ()
{
  local -a lines
  local _known_hosts="${HOME}/.ssh/known_hosts"
  if [[ -r "$_known_hosts" ]]
  then
    lines=({1..$(wc -l < "$_known_hosts")})
    _wanted lines expl 'line number' compadd -a lines
  fi
}

# bash 端
function _profile_ssh_forget_bash ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local _known_hosts="${HOME}/.ssh/known_hosts"
  local lines=''
  if [[ -r "$_known_hosts" ]]
  then
    lines=$(seq 1 "$(wc -l < "$_known_hosts")")
  fi
  COMPREPLY=($(compgen -W "$lines" -- "$cur"))
  return 0
}

# ==============================================================================
# 注册（按 shell 区分）
# ==============================================================================
if [[ -n "$ZSH_NAME" ]]
then
  compdef _profile_ssh_forget ssh_forget ssh-forget
else
  complete -F _profile_ssh_forget_bash ssh_forget ssh-forget
fi
