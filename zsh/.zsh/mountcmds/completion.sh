#!/usr/bin/env cat
# shellcheck shell=bash
# ==============================================================================
# mountcmds 补全（zsh + bash 通用）
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================
# 本文件由 loader.sh 自动 source，为 mountfat / mountntfs / mountiso /
# mountfs / mountdir / umount 提供 tab 补全。
# ==============================================================================

# ==============================================================================
# 补全函数定义
# ==============================================================================
# zsh 端
function _profile_mountfs ()
{
  curcontext="${curcontext:-}:mountfs"
  if [[ $CURRENT -eq 2 ]]
  then
    _files -g '/dev/*'
  elif [[ $CURRENT -eq 3 ]]
  then
    _files -/
  fi
}

function _profile_mountdir ()
{
  curcontext="${curcontext:-}:mountdir"
  _files -/
}

function _profile_umount ()
{
  local -a targets
  local _mp
  while read -r _mp
  do
    [[ -n "$_mp" ]] && targets+=("$_mp")
  done < <(mount 2>/dev/null | awk '{print $1; print $3}')
  compadd -a targets
}

# bash 端
function _profile_mount_bash ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  if [[ $COMP_CWORD -eq 1 ]]
  then
    # 第一个参数：块设备（/dev/*）或普通文件（用于 mountiso）
    local _devs=''
    if [[ -d /dev ]]
    then
      _devs=$(find /dev -maxdepth 1 -type b 2>/dev/null)
    fi
    COMPREPLY=($(compgen -W "$_devs" -- "$cur") $(compgen -f -- "$cur"))
  elif [[ $COMP_CWORD -eq 2 ]]
  then
    # 第二个参数：挂载点目录
    COMPREPLY=($(compgen -d -- "$cur"))
  fi
  return 0
}

function _profile_mountdir_bash ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -d -- "$cur"))
  return 0
}

function _profile_umount_bash ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local targets=''
  local _line=''
  while read -r _line
  do
    [[ -n "$_line" ]] && targets="$targets ${_line}"
  done < <(mount 2>/dev/null | awk '{print $1; print $3}')
  COMPREPLY=($(compgen -W "$targets" -- "$cur"))
  return 0
}

# ==============================================================================
# 注册（按 shell 区分）
# ==============================================================================
if [[ -n "$ZSH_NAME" ]]
then
  compdef _profile_mountfs mountfat mountntfs mountiso mountfs
  compdef _profile_mountdir mountdir
  compdef _profile_umount umount
else
  complete -F _profile_mount_bash mountfat mountntfs mountiso mountfs
  complete -F _profile_mountdir_bash mountdir
  complete -F _profile_umount_bash umount
fi
