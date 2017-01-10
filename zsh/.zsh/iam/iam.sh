#!/usr/bin/env cat
# ==============================================================================
# 根据GPG 密钥自动配置GIT 仓库环境变量
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

function iam ()
{
  local _fingerprint='4444949501B3CC2A76579C0825FFD92AB66CC194'
  local _git_author_name='Arondight'
  local _git_author_email='shell_way@foxmail.com'
  local _git_committer_email="$_git_author_email"

  if ! existcmd 'gpg'
  then
    return 0
  fi

  if gpg --list-secret-keys | grep -oP "^\h+${_fingerprint}$" >/dev/null 2>&1
  then
    export GIT_AUTHOR_NAME="$_git_author_name"
    export GIT_AUTHOR_EMAIL="$_git_author_email"
    export GIT_COMMITTER_EMAIL="$_git_committer_email"
  fi

  return $?
}

