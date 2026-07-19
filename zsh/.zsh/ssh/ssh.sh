#!/usr/bin/env cat
# shellcheck shell=bash
# ==============================================================================
# 删除 ~/.ssh/known_hosts 中的记录
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================
alias ssh-forget='ssh_forget'

function ssh_forget ()
{
  local line="$1" && shift
  local known_hosts="${HOME}/.ssh/known_hosts"

  if [[ ! "$line" =~ ^[1-9][0-9]*$ ]]
  then
    echo "Usage: ssh_forget <line-number>" >&2
    return 1
  fi

  if [[ -w "$known_hosts" ]]
  then
    sed -i "${line}d" "$known_hosts"
  else
    echo "\"${known_hosts}\" is not writable." >&2
    return 1
  fi

  return "$?"
}

