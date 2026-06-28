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

  echo 'Init profiles for bash ...'

  if [[ ! -d $BASHPROMPTDIR ]]
  then
    git clone "$BASHPROMPTURL" "$BASHPROMPTDIR"
  else
    pushd "$BASHPROMPTDIR" || exit
    {
      git pull --rebase --stat
    }
    popd || exit
  fi

  ret=$?
  echo 'done'

  exit $ret
}

