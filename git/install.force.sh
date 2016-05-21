#!/usr/bin/env bash
# ==============================================================================
# Force install profiles for git
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y-%m-%d_%T')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  GITCONFSRC="${WORKDIR}/.gitconfig"
  GITCONFDEST="${HOME}/.gitconfig"

  if [[ -e $GITCONFDEST ]]
  then
    if [[ -n $(md5sum $GITCONFSRC $GITCONFDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $GITCONFDEST "${GITCONFDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for git ...\t"

  if [[ ! -e $GITCONFDEST ]]
  then
    install -Dm0644 $GITCONFSRC $GITCONFDEST
  fi

  echo 'done'

  exit $?
}

