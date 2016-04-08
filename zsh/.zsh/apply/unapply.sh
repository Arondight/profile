#!/usr/bin/env cat
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

# ==============================================================================
# 撤销补丁
#
#                 by 秦凡东
# ==============================================================================
function unapply {
  local PATCH_CMD='patch'
  local patch_strip=$1
  local patch_file=$2

  if [[ -z $patch_file || -z $patch_strip ]]; then
    echo "Usage: unapply <patch_strip> <patch-file>"
    return 1
  fi

  if ! echo $patch_strip | grep -P '\d+' 2>&1 >/dev/null; then
    echo "<patch_strip> should be a integer, quit."
    return 1
  fi

  if [[ ! -r $patch_file ]]; then
    echo "\"$patch_file\" can not be read, quit."
    return 1
  fi

  env $PATCH_CMD -R -E -p $patch_strip <$patch_file

  return $?
}

