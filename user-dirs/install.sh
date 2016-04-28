#!/usr/bin/env bash
# ==============================================================================
# Install profiles for user-dirs
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y-%m-%d_%T')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  CONFDIR=${XDG_CONFIG_HOME:-${HOME}/.config}
  DIRSSRC="${WORKDIR}/user-dirs.dirs"
  DIRSDEST="${CONFDIR}/user-dirs.dirs"
  LOCALESRC="${WORKDIR}/user-dirs.locale"
  LOCALEDEST="${CONFDIR}/user-dirs.locale"

  mkdir -p $CONFDIR

  if [[ -e $DIRSDEST ]]
  then
    if [[ -n $(md5sum $DIRSSRC $DIRSDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $DIRSDEST "${DIRSDEST}.${SUFFIX}.bak"
    fi
  fi

  if [[ -e $LOCALEDEST ]]
  then
    if [[ -n $(md5sum $LOCALESRC $LOCALEDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $LOCALEDEST "${LOCALEDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for user-dirs ...\t"

  if [[ ! -e $DIRSDEST ]]
  then
    ln -sf $DIRSSRC $DIRSDEST
  fi

  if [[ ! -e $LOCALEDEST ]]
  then
    ln -sf $LOCALESRC $LOCALEDEST
  fi

  echo 'done'

  exit $?
}

