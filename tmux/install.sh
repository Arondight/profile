#!/usr/bin/env bash
# ==============================================================================
# Install profiles for tmux
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y-%m-%d_%T')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  TMUXCONFSRC="${WORKDIR}/.tmux.conf"
  TMUXCONFDEST="${HOME}/.tmux.conf"

  if [[ -e $TMUXCONFDEST ]]
  then
    if [[ -n $(md5sum $TMUXCONFSRC $TMUXCONFDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $TMUXCONFDEST "${TMUXCONFDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for tmux ...\t"

  if [[ ! -e $TMUXCONFDEST ]]
  then
    install $TMUXCONFSRC $TMUXCONFDEST
  fi

  echo 'done'

  exit $?
}

