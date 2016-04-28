#!/usr/bin/env bash
# ==============================================================================
# Install profiles for bash
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y-%m-%d_%T')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  BASHDIR="${HOME}/.bash"
  BASHRCSRC="${WORKDIR}/.bashrc"
  BASHRCDEST="${HOME}/.bashrc"
  INTERFACESHSRC="${WORKDIR}/.bash/interface.sh"
  INTERFACESHDEST="${HOME}/.bash/interface.sh"

  mkdir -p $BASHDIR

  if [[ -e $BASHRCDEST ]]
  then
    if [[ -n $(md5sum $BASHRCSRC $BASHRCDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $BASHRCDEST "${BASHRCDEST}.${SUFFIX}.bak"
    fi
  fi

  if [[ -e $INTERFACESHDEST ]]
  then
    if [[ -n $(md5sum $INTERFACESHSRC $INTERFACESHDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $INTERFACESHDEST "${INTERFACESHDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for bash ...\t"

  if [[ ! -e $BASHRCDEST ]]
  then
    ln -sf $BASHRCSRC $BASHRCDEST
  fi

  if [[ ! -e $INTERFACESHDEST ]]
  then
    ln -sf $INTERFACESHSRC $INTERFACESHDEST
  fi

  echo 'done'

  exit $?
}

