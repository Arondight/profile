#!/usr/bin/env bash
# ==============================================================================
# Check for installtion of vim's profiles
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

# MAIN:
{
  HEADERS=( $(find /usr/include -type f) )
  ret=0

  echo -ne "Checking vim ...\t"
  if ! type vim >/dev/null 2>&1
  then
    echo 'failed'
    ret=1
  else
    echo 'ok'
  fi

  echo -ne "Checking cmake ...\t"
  if ! type cmake >/dev/null 2>&1
  then
    echo 'failed'
    ret=1
  else
    echo 'ok'
  fi

  echo -ne "Checking gcc ...\t"
  if ! type gcc >/dev/null 2>&1
  then
    echo 'failed'
    ret=1
  else
    echo 'ok'
  fi

  echo -ne "Checking lua.h ...\t"
  if ! echo ${HEADERS[@]} | grep -P '\blua\.h\b' >/dev/null 2>&1
  then
    echo 'failed'
    ret=1
  else
    echo 'ok'
  fi

  echo -ne "Checking zlib.h ...\t"
  if ! echo ${HEADERS[@]} | grep -P '\bzlib\.h\b' >/dev/null 2>&1
  then
    echo 'failed'
    ret=1
  else
    echo 'ok'
  fi

  echo -ne "Checking curses.h ...\t"
  if ! echo ${HEADERS[@]} | grep -P '\bcurses\.h\b' >/dev/null 2>&1
  then
    echo 'failed'
    ret=1
  else
    echo 'ok'
  fi

  echo -ne "Checking clang ...\t"
  if ! type clang >/dev/null 2>&1
  then
    echo 'warning'
    ret=1
  else
    echo 'ok'
  fi

  echo -ne "Checking python-config ...\t"
  if ! type python-config >/dev/null 2>&1
  then
    echo 'failed'
    ret=1
  else
    echo 'ok'
  fi

  echo -ne "Checking xz ...\t"
  if ! type xz >/dev/null 2>&1
  then
    echo 'failed'
    ret=1
  else
    echo 'ok'
  fi

  exit $ret
}

