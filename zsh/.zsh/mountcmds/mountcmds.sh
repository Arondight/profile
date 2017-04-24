#!/usr/bin/env cat
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME
# ==============================================================================

# ==============================================================================
# 挂载设备合法性检查
# ==============================================================================
function _mount_dev_check ()
{
  local _point="$1"

  if [[ ! -b "$_point" ]]
  then
    return 0
  fi

  if ! echo "$_point" | grep -P '/dev/.+\d+' >/dev/null 2>&1
  then
    return 0
  fi

  return 1
}

# ==============================================================================
# 挂载点合法性检查
# ==============================================================================
function _mount_dir_check ()
{
  if [[ ! -d "$1" ]]
  then
    return 0
  fi

  return 1
}

# ==============================================================================
# fat32 分区挂载
# ==============================================================================
function mountfat ()
{
  if [[ "$#" < 2 ]]
  then
    return 1
  fi

  if ! _mount_dev_check "$1"
  then
    echo "\"${1}\" is not a device." >&2
    return 1
  fi

  if ! _mount_dir_check "$2"
  then
    echo "\"${2}\" is not a directory." >&2
    return 1
  fi

  echo "Mount \"${1}\" to \"${2}\""
  sudo mount "$1" "$2" -o iocharset=utf8,umask=000

  return "$?"
}

# ==============================================================================
# ntfs 分区挂载
# ==============================================================================
function mountntfs ()
{
  if [[ "$#" < 2 ]]
  then
    return 1
  fi

  if ! _mount_dev_check "$1"
  then
    echo "\"${1}\" is not a device." >&2
    return 1
  fi

  if ! _mount_dir_check "$2"
  then
    echo "\"${2}\" is not a directory." >&2
    return 1
  fi

  if existcmd ntfs-3g
  then
    echo "Mount \"${1}\" to \"${2}\""
    sudo ntfs-3g "$1" "$2"
  else
    mountfs "$1" "$2"
  fi

  return $?
}

# ==============================================================================
# iso 文件挂载
# ==============================================================================
function mountiso {
  if [[ "$#" < 2 ]]
  then
    return 1
  fi

  if ! _mount_dev_check "$1"
  then
    echo "\"${1}\" is not a device." >&2
    return 1
  fi

  if ! _mount_dir_check "$2"
  then
    echo "\"${2}\" is not a directory." >&2
    return 1
  fi

  echo "Mount \"${1}\" to \"${2}\""
  sudo mount "$1" "$2" -o loop

  return "$?"
}

# ==============================================================================
# 目录挂载
# ==============================================================================
function mountdir {
  local _dir=''

  if [[ "$#" < 2 ]]; then
    return 1
  fi

  for _dir in "$1" "$2"
  do
    _mount_dir_check "$_dir"
    if [[ 0 -eq $? ]]
    then
      echo "\"${dir}\" is not a directory." >&2
      return 1
    fi
  done

  echo "Mount \"${1}\" to \"${2}\""
  sudo mount --bind "$1" "$2"

  return "$?"
}

# ==============================================================================
# 其他分区挂载
# ==============================================================================
function mountfs {
  local _isdev=0
  local _isdir=0

  if [[ "$#" < 2 ]]
  then
    return 1
  fi

  _mount_dir_check "$1"
  _isdir="$?"
  _mount_dev_check "$1"
  _isdev="$?"

  if [[ 0 -ne "$_isdir" || 0 -ne "$_isdev" ]]
  then
    _mount_dir_check $2
    if [[ 0 -ne $? ]]
    then
      echo "\"${2}\" is not a directory." >&2
      return 1
    fi
    echo "Mount \"${1}\" to \"${2}\""
    sudo mount "$1" "$2" -o rw,nosuid,nodev,relatime,data=ordered
  else
    echo "\"${1}\" is not a device or directory." >&2
    return 1
  fi

  return "$?"
}

# ==============================================================================
# 卸载设备
# ==============================================================================
function umount {
  local _isdev=0
  local _isdir=0
  local _error=0
  local _file=''

  if [[ "$#" < 1 ]]; then
    return 1
  fi

  for _file in $@; do
    _mount_dir_check "$_file"
    _isdir="$?"
    _mount_dev_check "$_file"
    _isdev="$?"

    if [[ 1 -eq "$_isdir" || 1 -eq "$_isdev" ]]; then
      echo "Umount ${_file}"
      # Here MUST use "env" but "command"
      sudo env umount "$_file"
    else
      echo "\"${file}\" is not a device or directory." >&2
      _error+=1
      continue
    fi
  done

  return "$_error"
}

