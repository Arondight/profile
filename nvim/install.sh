#!/usr/bin/env bash
# ==============================================================================
# Install profiles for nvim
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y%m%d-%H%M%S')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  NVIMDIR="${XDG_CONFIG_HOME:-${HOME}/.config}/nvim"
  NVIMRCSRC="${HOME}/.vimrc"
  NVIMRCDEST="${NVIMDIR}/init.vim"

  mkdir -p $NVIMDIR
  NVIMRCSRC=$(readlink -f $NVIMRCSRC)

  if [[ -e $NVIMRCDEST ]]
  then
    if [[ -n $(md5sum $MPCONFSRC $NVIMRCDEST | awk '{print $1}' | uniq -u | tail -n 1) ]]
    then
      mv -v $NVIMRCDEST "${NVIMRCDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for nvim ...\t"

  if [[ ! -e $NVIMRCDEST ]]
  then
    ln -sf $NVIMRCSRC $NVIMRCDEST
  fi

  echo 'done'

  exit $?
}

