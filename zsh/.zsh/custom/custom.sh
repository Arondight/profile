#!/usr/bin/env cat
# shellcheck shell=bash
# ==============================================================================
# 读取~/.custom_shellrc
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

function customShellrc
{
  local _CUSTOM_SHELLRC="${HOME}/.custom_shellrc"

  if [[ -r "$_CUSTOM_SHELLRC" ]]
  then
    # shellcheck disable=SC1090
    source "$_CUSTOM_SHELLRC"
  fi

  return "$?"
}

