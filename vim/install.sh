#!/usr/bin/env bash
# ==============================================================================
# Install profiles for vim
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y-%m-%d_%T')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  VIMRCSRC="${WORKDIR}/.vimrc"
  VIMRCDEST="${HOME}/.vimrc"
  YCMRCSRC="${WORKDIR}/.ycm_extra_conf.py"
  YCMRCDEST="${HOME}/.ycm_extra_conf.py"

  if [[ -e $VIMRCDEST ]]
  then
    if [[ -n $(md5sum $VIMRCSRC $VIMRCDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $VIMRCDEST "${VIMRCDEST}.${SUFFIX}.bak"
    fi
  fi

  if [[ -e "$YCMRCDEST" ]]
  then
    if [[ -n $(md5sum $YCMRCSRC $YCMRCDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $YCMRCDEST "${YCMRCDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for vim ...\t"

  if [[ ! -e $VIMRCDEST ]]
  then
    ln -sf $VIMRCSRC $VIMRCDEST
  fi

  if [[ ! -e $YCMRCDEST ]]
  then
    ln -sf $YCMRCSRC $YCMRCDEST
  fi

  echo 'done'

  exit $?
}

