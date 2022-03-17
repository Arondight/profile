#!/usr/bin/env bash
# ==============================================================================
# Install profiles for zsh
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y%m%d-%H%M%S')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  ZSHRCSRC="${WORKDIR}/.zshrc"
  ZSHSRC="${WORKDIR}/.zsh"
  ZSHRCDEST="${HOME}/.zshrc"
  ZSHDEST="${HOME}/.zsh"
  LIBDIR="${HOME}/.lib"

  if [[ -e $ZSHRCDEST ]]
  then
    if [[ -n $(md5sum $ZSHRCSRC $ZSHRCDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $ZSHRCDEST "${ZSHRCDEST}.${SUFFIX}.bak"
    fi
  fi

  if [[ -e $ZSHDEST ]]
  then
    if [[ -L $ZSHDEST ]]
    then
      rm -vf $ZSHDEST
    else
      mv -v $ZSHRCDEST "${ZSHRCDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for zsh...\t"

  if [[ ! -e $ZSHRCDEST ]]
  then
    ln -sf $ZSHRCSRC $ZSHRCDEST
  fi

  if [[ ! -e $ZSHDEST ]]
  then
    ln -sf $ZSHSRC $ZSHDEST
  fi

  if [[ ! -d $LIBDIR ]]
  then
    mkdir -pv $LIBDIR
  fi

  echo 'done'

  exit 0
}

