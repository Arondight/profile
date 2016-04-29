#!/usr/bin/env cat
# ==============================================================================
# 在Vim 中查看Manual
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

function vman {
  local section=''

  if [[ $# < 1 ]]; then
    return 0
  fi

  for key in $@; do
    if echo $key | grep -P '^[1-9]$' >/dev/null 2>&1; then
      section=$key
    else
      vim -c "Man $section $key" -c 'only'
    fi

  done
}

