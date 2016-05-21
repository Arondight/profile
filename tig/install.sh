#!/usr/bin/env bash
# ==============================================================================
# Install profiles for tig
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y-%m-%d_%T')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  TIGRCSRC="${WORKDIR}/.tigrc"
  TIGRCDEST="${HOME}/.tigrc"

  if [[ -e $TIGRCDEST ]]
  then
    if [[ -n $(md5sum $TIGRCSRC $TIGRCDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $TIGRCDEST "${TIGRCDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for git ...\t"

  if [[ ! -e $TIGRCDEST ]]
  then
    install -Dm0644 $TIGRCSRC $TIGRCDEST
  fi

  echo 'done'

  exit $?
}

