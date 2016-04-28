#!/usr/bin/env bash
# ==============================================================================
# Install profiles for nano
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y-%m-%d_%T')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  NANODIR="${HOME}/.nano"
  NANORCSRC="${WORKDIR}/.nanorc"
  NANORCDEST="${HOME}/.nanorc"
  NANOSRC="${WORKDIR}/.nano"
  NANODEST=$NANODIR

  mkdir -p $NANODIR

  if [[ -e $NANORCDEST ]]
  then
    if [[ -n $(md5sum $NANORCSRC $NANORCDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $NANORCDEST "${NANORCDEST}.${SUFFIX}.bak"
    fi
  fi

  if [[ -e $NANODEST ]]
  then
    if [[ -L $NANORCDEST && $NANOSRC == $(readlink -f $NANODEST) ]]
    then
      :
    else
      mv -v $NANODEST "${NANODEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for nano ...\t"

  if [[ ! -e $NANORCDEST ]]
  then
    ln -sf $NANORCSRC $NANORCDEST
  fi

  if [[ ! -e $NANODEST ]]
  then
    ln -sf $NANOSRC $NANODEST
  fi

  echo 'done'

  exit $?
}

