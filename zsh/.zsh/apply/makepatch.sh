#!/usr/bin/env cat
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

# ==============================================================================
# 制作补丁
#
#                 by 秦凡东
# ==============================================================================
function makepatch {
  local DIFF_CMD='diff'
  local patch_base=$1
  local patch_target=$2
  local patch_file=$3

  if [[ -z $patch_base || -z $patch_target || -z $patch_file ]]; then
    echo "Usage: apply <patch_base> <patch-target> <patch_file>"
    return 1
  fi

  if [[ ! -e $patch_base ]]; then
    echo "\"$patch_base\" is not exist, quit."
    return 1
  fi

  if [[ ! -e $patch_target ]]; then
    echo "\"$patch_target\" is not exist, quit."
    return 1
  fi

  if [[ -e $patch_file ]]; then
    echo "\"$patch_file\" has already exist, quit and do nothing."
    return 1
  fi

  env $DIFF_CMD -N -u -r $patch_base $patch_target >$patch_file

  return $?
}

