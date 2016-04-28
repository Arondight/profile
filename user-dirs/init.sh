#!/usr/bin/env bash
# ==============================================================================
# Do init for profiles of user-dirs
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

# MAIN:
{
  DIRSFILE="${HOME}/.config/user-dirs.dirs"
  DIRREGEX='(?<=\=\").+(?=\"$)'
  userdirs=''
  dir=''

  userdirs=( $(grep -oP $DIRREGEX $DIRSFILE) )

  echo -ne "Init profiles for user-dirs ...\t"

  for dir in ${userdirs[@]}
  do
    eval mkdir -p $dir
  done

  echo 'done'

  exit $?
}

