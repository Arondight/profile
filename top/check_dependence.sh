#!/usr/bin/env bash

error=0

echo -ne "检查top...\t"
if ! type top >/dev/null 2>&1; then
  echo '警告。'
else
  echo '成功'
fi

if [[ 1 -eq $error ]]; then
  exit $error
fi

