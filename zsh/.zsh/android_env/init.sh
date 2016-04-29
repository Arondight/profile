#!/usr/bin/env bash
# ==============================================================================
# 在现代系统上使用libtinfo 和libncurses
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

# MAIN:
{
  LIBNCURSESW='/usr/lib/libncursesw.so.6'
  lib=''

  if [[ ! -e $LIBNCURSESW ]]
  then
    echo "$LIBNCURSESW in not found, quit."
    exit 1
  fi

  for lib in /usr/lib/{libtinfo.so{,.5,.6},libncurses.so{.5,.6}}
  do
    if [[ ! -e $lib ]]
    then
      sudo ln -s $LIBNCURSESW $lib  \
        && echo "$lib -> $LIBNCURSESW"
    fi
  done
}

