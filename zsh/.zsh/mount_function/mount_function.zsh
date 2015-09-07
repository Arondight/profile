#!/usr/bin/env zsh
# ======================== #
# 挂载函数                 #
#                          #
#             By 秦凡东    #
# ======================== #

# fat32 分区挂载
function mountfat {
  if [[ $# < 2 ]]; then
    return 1
  fi
  sudo mount $1 $2 -o iocharset=utf8,umask=000
  return $?
}

# ntfs 分区挂载
function mountntfs {
  if [[ $# < 2 ]]; then
    return 1
  fi
  if type ntfs-3g >/dev/null 2>&1; then
    sudo ntfs-3g $1 $2
  else
    mountfs $1 $2
  fi
  return $?
}

# iso 文件挂载
function mountiso {
  if [[ $# < 2 ]]; then
    return 1
  fi
  sudo mount $1 $2 -o loop
  return $?
}

# 目录挂载
function mountdir {
  if [[ $# < 2 ]]; then
    return 1
  fi
  sudo mount --bind $1 $2
  return $?
}

# 其他分区挂载
function mountfs {
  if [[ $# < 2 ]]; then
    return 1
  fi
  sudo mount $1 $2 -o noauto,async,noexec,rw
  return $?
}

# 卸载设备
function umount {
  if [[ $# < 1 ]]; then
    return 1
  fi
  for name in $@; do
    sudo umount $name
  done
  return $?
}

