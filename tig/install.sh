#!/usr/bin/env bash
# ==============================================================================
# Install profiles for tig
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y%m%d-%H%M%S')
WORKDIR="$(dirname "$(readlink -f "$0")")"

# MAIN:
{
  TIGRCSRC="${WORKDIR}/.tigrc"
  TIGRCDEST="${HOME}/.tigrc"

  if [[ -e $TIGRCDEST ]]
  then
    if ! cmp -s "$TIGRCSRC" "$TIGRCDEST"
    then
      mv -v "$TIGRCDEST" "${TIGRCDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for tig ...\t"

  if [[ ! -e $TIGRCDEST ]]
  then
    install -Dm0644 "$TIGRCSRC" "$TIGRCDEST"
  fi

  ret=$?
  echo 'done'

  exit $ret
}

