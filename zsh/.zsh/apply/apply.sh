#!/usr/bin/env cat
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

# ==============================================================================
# 打补丁
#
#                 by 秦凡东
# ==============================================================================
function apply {
  local PATCH_CMD='patch'
  local patch_strip=$1
  local patch_file=$2

  if [[ -z $patch_file || -z $patch_strip ]]; then
    echo "Usage: apply <strip> <patch-file>"
    return 1
  fi

  if ! echo $patch_strip | grep -P '\d+' 2>&1 >/dev/null; then
    echo "<strip> should be a integer, quit."
    return 1
  fi

  if [[ ! -r $patch_file ]]; then
    echo "\"$patch_file\" can not be read, quit."
    return 1
  fi

  env $PATCH_CMD -p $patch_strip <$patch_file

  return $?
}

