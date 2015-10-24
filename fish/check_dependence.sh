#!/usr/bin/env bash

error=0

echo -ne "检查fish...\t"
if [[ ! -x /usr/bin/fish ]]; then
  echo '警告。'
else
  echo '成功'
fi

if [[ 1 -eq $error ]]; then
  exit $error
fi

