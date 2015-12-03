#!/usr/bin/env bash

error=0

echo -ne "检查vim...\t"
if ! type vim >/dev/null 2>&1; then
  echo '失败'
  error=1
else
  echo '成功'
fi

echo -ne "检查cmake...\t"
if ! type cmake >/dev/null 2>&1; then
  echo '失败'
  error=1
else
  echo '成功'
fi

echo -ne "检查gcc...\t"
if ! type gcc >/dev/null 2>&1; then
  echo '失败'
  error=1
else
  echo '成功'
fi

echo -ne "检查lua.h...\t"
lua=$(find /usr/include -name 'lua.h')
if [[ -z $lua ]]; then
  echo '失败'
  error=1
else
  echo '成功'
fi

echo -ne "检查zlib...\t"
zlib=$(find /usr/include -name 'zlib.h')
if [[ -z $zlib ]]; then
  echo '失败'
  error=1
else
  echo '成功'
fi

echo -ne "检查ncurses...\t"
ncurses=$(find /usr/include -name 'curses.h')
if [[ -z $ncurses ]]; then
  echo '失败'
  error=1
else
  echo '成功'
fi

echo -ne "检查clang...\t"
if ! type clang >/dev/null 2>&1; then
  echo '失败'
  error=1
else
  echo '成功'
fi

echo -ne "检查python-config...\t"
if ! type python-config >/dev/null 2>&1; then
  echo '失败'
  error=1
else
  echo '成功'
fi

echo -ne "检查libclang.so...\t"
if [[ ! -e /usr/lib/libclang.so ]]; then
  echo '警告'
else
  echo '成功'
fi

echo -ne "检查xz...\t"
if ! type xz >/dev/null 2>&1; then
  echo '失败'
  error=1
else
  echo '成功'
fi

if [[ 1 -eq $error ]]; then
  exit $error
fi

