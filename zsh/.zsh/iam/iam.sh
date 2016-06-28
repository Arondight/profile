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
  local FINGERPRINT='4444949501B3CC2A76579C0825FFD92AB66CC194'
  local GIT_AUTHOR_NAME_VALUE='Arondight'
  local GIT_AUTHOR_EMAIL_VALUE='shell_way@foxmail.com'
  local GIT_COMMITTER_EMAIL_VALUE=$GIT_AUTHOR_EMAIL_VALUE

  if !type gpg >/dev/null 2>&1
  then
    return 0
  fi

  if gpg --list-secret-keys | grep -oP "^\h+${FINGERPRINT}$" >/dev/null 2>&1
  then
    export GIT_AUTHOR_NAME=$GIT_AUTHOR_NAME_VALUE
    export GIT_AUTHOR_EMAIL=$GIT_AUTHOR_EMAIL_VALUE
    export GIT_COMMITTER_EMAIL=$GIT_COMMITTER_EMAIL_VALUE
  fi

  return $?
}

