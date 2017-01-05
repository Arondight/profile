#!/usr/bin/env bash
# ==============================================================================
# Install profiles for mplayer
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y%m%d-%H%M%S')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  MPDIR="${HOME}/.mplayer"
  MPCONFSRC="${WORKDIR}/config"
  MPCONFDEST="${MPDIR}/config"

  mkdir -p $MPDIR

  if [[ -e $MPCONFDEST ]]
  then
    if [[ -n $(md5sum $MPCONFSRC $MPCONFDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $MPCONFDEST "${MPCONFDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for mplayer ...\t"

  if [[ ! -e $MPCONFDEST ]]
  then
    ln -sf $MPCONFSRC $MPCONFDEST
  fi

  echo 'done'

  exit $?
}

