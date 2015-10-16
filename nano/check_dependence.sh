#!/usr/bin/env bash

error=0

echo -ne "检查nano...\t"
if ! type nano >/dev/null 2>&1; then
  echo '警告。'
else
  echo '成功'
fi

if [[ 1 -eq $error ]]; then
  exit $error
fi

