#!/usr/bin/env bash

target='/usr/lib/libncursesw.so.6'

if [[ ! -e $target ]]; then
  echo "$target in not found, quit."
  exit 1
fi

for lib in /usr/lib/{libtinfo.so{,.5,.6},libncurses.so{.5,.6}}; do
  if [[ ! -e $lib ]]; then
    sudo ln -s $target $lib
    echo "$lib -> $target"
  fi
done

