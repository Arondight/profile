#!/usr/bin/env bash
# ==============================================================================
# Install profiles for tmux
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y%m%d-%H%M%S')
WORKDIR="$(dirname "$(readlink -f "$0")")"

# MAIN:
{
  TMUXCONFSRC="${WORKDIR}/.tmux.conf"
  TMUXCONFDEST="${HOME}/.tmux.conf"

  if [[ -e $TMUXCONFDEST ]]
  then
    if ! cmp -s "$TMUXCONFSRC" "$TMUXCONFDEST"
    then
      mv -v "$TMUXCONFDEST" "${TMUXCONFDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for tmux ...\t"

  if [[ ! -e $TMUXCONFDEST ]]
  then
    install -Dm0644 "$TMUXCONFSRC" "$TMUXCONFDEST"
  fi

  ret=$?
  echo 'done'

  exit $ret
}

