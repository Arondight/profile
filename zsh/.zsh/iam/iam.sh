#!/usr/bin/env cat
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

# ==============================================================================
# 为当前git 仓库配置user 信息
#
#                 by 秦凡东
# ==============================================================================
function iam {
  local topdir=$(readlink -f $(pwd))
  local name=$1
  local email=$2

  if ! groot >/dev/null 2>&1; then
    echo "Not a git repository, quit."
    return 1
  else
    echo "Change to top of current git repository."
  fi

  if [[ -z $name ]]; then
    name='Arondight'
  fi

  if [[ -z $email ]]; then
    email='shell_way@foxmail.com'
  fi

  echo "Set user.name to $name"
  env git config user.name $name
  echo "Set user.email to $email"
  env git config user.email $email

  return $?
}

