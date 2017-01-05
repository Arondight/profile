#!/usr/bin/env bash
# ==============================================================================
# Install profiles for top
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y%m%d-%H%M%S')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  TOPRCSRC="${WORKDIR}/.toprc"
  TOPRCDEST="${HOME}/.toprc"

  if [[ -e $TOPRCDEST ]]
  then
    if [[ -n $(md5sum $TOPRCSRC $TOPRCDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $TOPRCDEST "${TOPRCDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for top ...\t"

  if [[ ! -e $TOPRCDEST ]]
  then
    install -Dm0644 $TOPRCSRC $TOPRCDEST
  fi

  echo 'done'

  exit $?
}

