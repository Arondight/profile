#!/usr/bin/env bash

suffix=$(date +%s)
[[ -z $curdir ]] && curdir=$(dirname $(readlink -f $0))
src_dirs="$curdir/user-dirs.dirs"
src_locale="$curdir/user-dirs.locale"
dest_dirs="$HOME/.config/user-dirs.dirs"
dest_locale="$HOME/.config/user-dirs.locale"

if [[ -d "$(dirname $dest_dirs)" ]]; then
  if [[ -f "$dest_dirs" || -L "$dest_dirs" ]]; then
    mv "$dest_dirs" "$dest_dirs.${suffix}.bak"
  fi
  if [[ -f "$dest_locale" || -L "$dest_locale" ]]; then
    mv "$dest_locale" "$dest_locale.${suffix}.bak"
  fi
else
  mkdir "$(dirname $dest_dirs)"
fi

echo -ne "配置user-dirs...\t"
ln -s "$src_dirs" "$dest_dirs"
ln -s "$src_locale" "$dest_locale"
echo '完成'

