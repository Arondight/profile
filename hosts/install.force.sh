#!/usr/bin/env bash
# ==============================================================================
# Force install profiles for hosts
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y%m%d-%H%M%S')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  HOSTSSRC="${WORKDIR}/hosts"
  HOSTSDEST='/etc/hosts'

  if [[ -e $HOSTSDEST ]]
  then
    if [[ -n $(md5sum $HOSTSSRC $HOSTSDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $HOSTSDEST "${HOSTSDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for hosts ...\t"

  if [[ ! -e $HOSTSDEST ]]
  then
    sudo install -Dm0644 $HOSTSSRC $HOSTSDEST
  fi

  echo 'done'

  exit $?
}

