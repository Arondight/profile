#!/usr/bin/env bash
# ==============================================================================
# Check for installtion of vim's profiles
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

# MAIN:
{
  HEADERS=( $(find /usr/include -type f) )
  LIBDIRS=( /lib{,64} /usr/lib{,64} )
  LIBS=()
  ret=0

  #for _dir in ${LIBDIRS[@]}
  #do
  #  if [[ -d "$_dir" && ! -L "$_dir" ]]
  #  then
  #    LIBS=( ${LIBS[@]} $(find "$_dir" -type f) )
  #  fi
  #done

  echo -ne "Checking vim ...\t"
  if ! type vim >/dev/null 2>&1
  then
    echo 'failed'
    ret=1
  else
    echo 'ok'
  fi

  #echo -ne "Checking cmake ...\t"
  #if ! type cmake >/dev/null 2>&1
  #then
  #  echo 'failed'
  #  ret=1
  #else
  #  echo 'ok'
  #fi

  #echo -ne "Checking gcc ...\t"
  #if ! type gcc >/dev/null 2>&1
  #then
  #  echo 'failed'
  #  ret=1
  #else
  #  echo 'ok'
  #fi

  #echo -ne "Checking lua.h ...\t"
  #if ! echo ${HEADERS[@]} | grep -oP '\blua\.h\b' >/dev/null 2>&1
  #then
  #  echo 'failed'
  #  ret=1
  #else
  #  echo 'ok'
  #fi

  #echo -ne "Checking zlib.h ...\t"
  #if ! echo ${HEADERS[@]} | grep -oP '\bzlib\.h\b' >/dev/null 2>&1
  #then
  #  echo 'failed'
  #  ret=1
  #else
  #  echo 'ok'
  #fi

  #echo -ne "Checking curses.h ...\t"
  #if ! echo ${HEADERS[@]} | grep -oP '\bcurses\.h\b' >/dev/null 2>&1
  #then
  #  echo 'failed'
  #  ret=1
  #else
  #  echo 'ok'
  #fi

  echo -ne "Checking clang ...\t"
  if ! type clang >/dev/null 2>&1
  then
    echo 'failed'
    ret=1
  else
    echo 'ok'
  fi

  #echo -ne "Checking python-config ...\t"
  #if ! type python-config >/dev/null 2>&1
  #then
  #  echo 'failed'
  #  ret=1
  #else
  #  echo 'ok'
  #fi

  #echo -ne "Checking xz ...\t"
  #if ! type xz >/dev/null 2>&1
  #then
  #  echo 'failed'
  #  ret=1
  #else
  #  echo 'ok'
  #fi

  #echo -ne "Checking libtinfo ...\t"
  #if ! echo ${LIBS[@]} | grep -oP '\blibtinfo\.so\.5\b' >/dev/null 2>&1
  #then
  #  echo -e "failed\tSee git repository's README.md file for more info."
  #  ret=1
  #else
  #  echo 'ok'
  #fi

  echo -ne "Checking /usr/lib/libclang.so ...\t"
  if [[ ! -e /usr/lib/libclang.so ]]
  then
    echo -e "warnning"
  else
    echo 'ok'
  fi

  exit $ret
}

