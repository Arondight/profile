#!/usr/bin/env bash
# ==============================================================================
# Install profiles for top
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y%m%d-%H%M%S')
WORKDIR="$(dirname "$(readlink -f "$0")")"

# MAIN:
{
  TOPRCSRC="${WORKDIR}/.toprc"
  TOPRCDEST="${HOME}/.toprc"

  if [[ -e $TOPRCDEST ]]
  then
    if ! cmp -s "$TOPRCSRC" "$TOPRCDEST"
    then
      mv -v "$TOPRCDEST" "${TOPRCDEST}.${SUFFIX}.bak"
    fi
  fi

  echo -ne "Install profiles for top ...\t"

  if [[ ! -e $TOPRCDEST ]]
  then
    install -Dm0644 "$TOPRCSRC" "$TOPRCDEST"
  fi

  ret=$?
  echo 'done'

  exit $ret
}

