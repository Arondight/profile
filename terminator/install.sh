#!/usr/bin/env bash
# ==============================================================================
# Install profiles for terminator
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y-%m-%d_%T')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  TMNTDIR="${XDG_CONFIG_HOME:-${HOME}/.config}/terminator"
  TMNTCONFSRC="${WORKDIR}/config"
  TMNTCONFDEST="${TMNTDIR}/config"

  mkdir -p $TMNTDIR

  if [[ -e $TMNTCONFDEST ]]
  then
    if [[ -n $(md5sum $TMNTCONFSRC $TMNTCONFDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $TMNTCONFDEST "${TMNTCONFDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for terminator ...\t"

  if [[ ! -e $TMNTCONFDEST ]]
  then
    ln -sf $TMNTCONFSRC $TMNTCONFDEST
  fi

  echo 'done'

  exit $?
}

