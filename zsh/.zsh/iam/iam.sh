#!/usr/bin/env cat
# ==============================================================================
# 为当前git 仓库配置user 信息
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

function iam ()
{
  local name=$1
  local email=$2

  if ! groot >/dev/null 2>&1
  then
    echo "Not a git repository, quit." >&2
    return 1
  else
    echo "Change to top of current git repository."
  fi

  if [[ -z $name ]]
  then
    name='Arondight'
  fi

  if [[ -z $email ]]
  then
    email='shell_way@foxmail.com'
  fi

  echo "Set user.name to ${name}"
  env git config user.name $name
  echo "Set user.email to ${email}"
  env git config user.email $email

  return $?
}

