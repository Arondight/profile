#!/usr/bin/env cat
# ==============================================================================
# 删除~/.ssh/known_hosts 中的记录
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

  if [[ -w "$known_hosts" ]]
  then
    sed -i "${line}d" "$known_hosts"
  fi

  return "$?"
}

