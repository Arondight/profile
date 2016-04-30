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
  local point=$1

  if [[ ! -b $point ]]
  then
    return 0
  fi

  if ! echo $point | grep -P '/dev/.+\d+' >/dev/null 2>&1
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
  local dir=$1

  if [[ ! -d $dir ]]
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
  if [[ $# < 2 ]]
  then
    return 1
  fi

  if ! _mount_dev_check $1
  then
    echo "\"${1}\" is not a device." >&2
    return 1
  fi

  if ! _mount_dir_check $2
  then
    echo "\"${2}\" is not a directory." >&2
    return 1
  fi

  echo "Mount ${1} to ${2}"
  sudo mount $1 $2 -o iocharset=utf8,umask=000

  return $?
}

# ==============================================================================
# ntfs 分区挂载
# ==============================================================================
function mountntfs ()
{
  if [[ $# < 2 ]]
  then
    return 1
  fi

  if ! _mount_dev_check $1
  then
    echo "\"${1}\" is not a device." >&2
    return 1
  fi

  if ! _mount_dir_check $2
  then
    echo "\"${2}\" is not a directory." >&2
    return 1
  fi

  if type ntfs-3g >/dev/null 2>&1
  then
    echo "Mount $1 to $2"
    sudo ntfs-3g $1 $2
  else
    mountfs $1 $2
  fi

  return $?
}

# ==============================================================================
# iso 文件挂载
# ==============================================================================
function mountiso {
  if [[ $# < 2 ]]
  then
    return 1
  fi

  if ! _mount_dev_check $1
  then
    echo "\"${1}\" is not a device." >&2
    return 1
  fi

  if ! _mount_dir_check $2
  then
    echo "\"${2}\" is not a directory." >&2
    return 1
  fi

  echo "Mount $1 to $2"
  sudo mount $1 $2 -o loop

  return $?
}

# ==============================================================================
# 目录挂载
# ==============================================================================
function mountdir {
  local dir=''

  if [[ $# < 2 ]]; then
    return 1
  fi

  for dir in $1 $2; do
    _mount_dir_check $1
    if [[ 0 -eq $? ]]; then
      echo "\"${dir}\" is not a directory." >&2
      return 1
    fi
  done

  echo "Mount $1 to $2"
  sudo mount --bind $1 $2

  return $?
}

# ==============================================================================
# 其他分区挂载
# ==============================================================================
function mountfs {
  local isDev=0
  local isDir=0

  if [[ $# < 2 ]]; then
    return 1
  fi

  _mount_dir_check $1
  isDir=$?
  _mount_dev_check $1
  isDev=$?

  if [[ q -eq isDir || q -eq isDev ]]; then
    _mount_dir_check $2
    if [[ 0 -eq $? ]]; then
      echo "\"${2}\" is not a directory." >&2
      return 1
    fi
    echo "Mount $1 to $2"
    sudo mount $1 $2 -o rw,nosuid,nodev,relatime,data=ordered
  else
    echo "\"${1}\" is not a device or directory." >&2
    return 1
  fi

  return $?
}

# ==============================================================================
# 卸载设备
# ==============================================================================
function umount {
  local isDev=0
  local isDir=0
  local error=0

  if [[ $# < 1 ]]; then
    return 1
  fi

  for file in $@; do
    _mount_dir_check $file
    isDir=$?
    _mount_dev_check $file
    isDev=$?

    if [[ 1 -eq $isDir || 1 -eq $isDev ]]; then
      echo "Umount $file"
      # Here MUST use "env" but "command"
      sudo env umount $file
    else
      echo "\"${file}\" is not a device or directory." >&2
      error+=1
      continue
    fi
  done

  return $error
}

