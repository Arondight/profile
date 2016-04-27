#!/usr/bin/env bash

error=0

echo -ne "检查nvim...\t"
if ! type nvim >/dev/null 2>&1; then
  echo '警告'
else
  echo '成功'
fi

