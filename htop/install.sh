#!/usr/bin/env bash
# ==============================================================================
# Install profiles for htop
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y%m%d-%H%M%S')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  HTOPRCSRC="${WORKDIR}/htoprc"
  HTOPRCDEST="${HOME}/.config/htop/htoprc"

  if [[ -e $HTOPRCDEST ]]
  then
    if [[ -n $(md5sum $HTOPRCSRC $HTOPRCDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $HTOPRCDEST "${HTOPRCDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for htop ...\t"

  if [[ ! -e $HTOPRCDEST ]]
  then
    install -Dm0644 $HTOPRCSRC $HTOPRCDEST
  fi

  echo 'done'

  exit $?
}

