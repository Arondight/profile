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
  GITPULLCMD='git pull --rebase --stat'

  echo 'Init profiles for bash ...'

  if [[ ! -d $BASHPROMPTDIR ]]
  then
    git clone $BASHPROMPTURL $BASHPROMPTDIR
  else
    cd $BASHPROMPTDIR && command $GITPULLCMD
  fi

  echo 'done'

  exit $?
}

