#!/usr/bin/env bash
# ==============================================================================
# Install profiles for redshift
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y%m%d-%H%M%S')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  CONFDIR=${XDG_CONFIG_HOME:-${HOME}/.config}
  RSCONFSRC="${WORKDIR}/redshift.conf"
  RSCONFDEST="${CONFDIR}/redshift.conf"

  mkdir -p $CONFDIR

  if [[ -e $RSCONFDEST ]]
  then
    if [[ -n $(md5sum $RSCONFSRC $RSCONFDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $RSCONFDEST "${RSCONFDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for redshift ...\t"

  if [[ ! -e $RSCONFDEST ]]
  then
    ln -sf $RSCONFSRC $RSCONFDEST
  fi

  echo 'done'

  exit $?
}

