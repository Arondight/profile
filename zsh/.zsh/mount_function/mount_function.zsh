#!/usr/bin/env zsh
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
    echo "$point 不是设备文件"
    return 0
  fi

  if ! echo $point | grep -P '/dev/.+\d+' >/dev/null 2>&1; then
    echo "$point 不是一个分区设备"
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
    echo "$dir 不是目录或不存在"
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
  if [[ 0 == $? ]]; then
    return 1
  fi

  _mount_dir_check $2
  if [[ 0 == $? ]]; then
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
  if [[ 0 == $? ]]; then
    return 1
  fi

  _mount_dir_check $2
  if [[ 0 == $? ]]; then
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
  if [[ 0 == $? ]]; then
    return 1
  fi

  _mount_dir_check $2
  if [[ 0 == $? ]]; then
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
    if [[ 0 == $? ]]; then
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
  if [[ $# < 2 ]]; then
    return 1
  fi

  _mount_dev_check $1
  if [[ 0 == $? ]]; then
    return 1
  fi

  _mount_dir_check $2
  if [[ 0 == $? ]]; then
    return 1
  fi

  echo "Mount $1 to $2"
  sudo mount $1 $2 -o rw,nosuid,nodev,relatime,data=ordered

  return $?
}

# ==============================================================================
# 卸载设备
# ==============================================================================
function umount {
  error=0

  if [[ $# < 1 ]]; then
    return 1
  fi
  for dir in $@; do
    _mount_dir_check $dir
    if [[ 0 == $? ]]; then
      continue 1
    fi

    echo "Umount $dir"
    sudo env umount $dir
  done

  return $error
}

