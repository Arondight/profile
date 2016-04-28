#!/usr/bin/env bash
# ==============================================================================
# Do init for profiles of bash
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

# MAIN:
{
  BASHPROMPTDIR="${HOME}/.bash/bash-git-prompt"
  BASHPROMPTURL='https://github.com/magicmonty/bash-git-prompt'

  echo -ne "Init profiles for bash ...\t"

  if [[ ! -d $BASHPROMPTDIR ]]; then
    git clone $BASHPROMPTURL $BASHPROMPTDIR
  fi

  echo 'done'

  exit $?
}

