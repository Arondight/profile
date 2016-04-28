#!/usr/bin/env bash
# ==============================================================================
# Install profiles for vsftpd
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

SUFFIX=$(date +'%Y-%m-%d_%T')
WORKDIR=$(dirname $(readlink -f $0))

# MAIN:
{
  echo -ne "Install profiles for vsftpd ...\t"
  echo "skip"
}

