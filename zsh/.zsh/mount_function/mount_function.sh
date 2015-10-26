#!/usr/bin/env bash
# ==============================================================================
# 挂载函数
#
#             By 秦凡东
# ==============================================================================

# ==============================================================================
# 挂载设备合法性检查
# ==============================================================================
function _mount_dev_check {
  local point=$1

  if [[ ! -b $point ]]; then
    return 0
  fi

  if ! echo $point | grep -P '/dev/.+\d+' >/dev/null 2>&1; then
    return 0
  fi

  return 1
}

# ==============================================================================
# 挂载点合法性检查
# ==============================================================================
function _mount_dir_check {
  local dir=$1

  if [[ ! -d $dir ]]; then
    return 0
  fi

  return 1
}

# ==============================================================================
# fat32 分区挂载
# ==============================================================================
function mountfat {
  if [[ $# < 2 ]]; then
    return 1
  fi

  _mount_dev_check $1
  if [[ 0 -eq $? ]]; then
    echo "$1 不是设备"
    return 1
  fi

  _mount_dir_check $2
  if [[ 0 -eq $? ]]; then
    echo "$2 不是目录"
    return 1
  fi

  echo "Mount $1 to $2"
  sudo mount $1 $2 -o iocharset=utf8,umask=000

  return $?
}

# ==============================================================================
# ntfs 分区挂载
# ==============================================================================
function mountntfs {
  if [[ $# < 2 ]]; then
    return 1
  fi

  _mount_dev_check $1
  if [[ 0 -eq $? ]]; then
    echo "$1 不是设备"
    return 1
  fi

  _mount_dir_check $2
  if [[ 0 -eq $? ]]; then
    echo "$2 不是目录"
    return 1
  fi

  if type ntfs-3g >/dev/null 2>&1; then
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
  if [[ $# < 2 ]]; then
    return 1
  fi

  _mount_dev_check $1
  if [[ 0 -eq $? ]]; then
    echo "$1 不是设备"
    return 1
  fi

  _mount_dir_check $2
  if [[ 0 -eq $? ]]; then
    echo "$2 不是目录"
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
  if [[ $# < 2 ]]; then
    return 1
  fi

  for dir in $1 $2; do
    _mount_dir_check $1
    if [[ 0 -eq $? ]]; then
      echo "$dir 不是目录"
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
  local is_dev=0
  local is_dir=0

  if [[ $# < 2 ]]; then
    return 1
  fi

  _mount_dir_check $1
  is_dir=$?
  _mount_dev_check $1
  is_dev=$?

  if [[ q -eq is_dir || q -eq is_dev ]]; then
    _mount_dir_check $2
    if [[ 0 -eq $? ]]; then
      echo "$2 不是目录"
      return 1
    fi
    echo "Mount $1 to $2"
    sudo mount $1 $2 -o rw,nosuid,nodev,relatime,data=ordered
  else
    echo "$1 不是设备或者目录"
    return 1
  fi

  return $?
}

# ==============================================================================
# 卸载设备
# ==============================================================================
function umount {
  local is_dev=0
  local is_dir=0
  local error=0

  if [[ $# < 1 ]]; then
    return 1
  fi

  for file in $@; do
    _mount_dir_check $file
    is_dir=$?
    _mount_dev_check $file
    is_dev=$?

    if [[ (1 -eq is_dir) || (1 -eq is_dev) ]]; then
      echo "Umount $file"
      sudo env umount $file
    else
      echo "$file 不是设备或者挂载点"
      error+=1
      continue
    fi
  done

  return $error
}

