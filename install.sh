#!/usr/bin/env bash

if [[ 0 -eq $# ]]; then
  set -- '--help'
fi

do_check=0
do_install=0
do_dependence=0

while true; do
  case $1 in
    -c|--check-dependence)
      shift
      do_check=1
      ;;
    -i|--install)
      shift
      do_install=1
      ;;
    -d|--install-dependence)
      shift
      do_dependence=1
      ;;
    -h|--help)
      shift
      cat << END_OF_HELP
用法：
  ./install.sh [选项]...
选项：
  -h, --help                  显示帮助信息
  -c, --check-dependence      检查基本依赖
  -i, --install               安装配置文件
  -d, --install-dependence    安装依赖环境
示例：
  ./install.sh -c -i -d
END_OF_HELP
      exit 0
      ;;
    *)
      break
    ;;
  esac
done

# do_check {
if [[ 1 -eq $do_check ]]; then
  error=0

  echo '正在检查所需依赖...'
  echo -ne "检测git...\t"
  if ! type git >/dev/null 2>&1; then
    echo '错误'
    error=1
  else
    echo '成功'
  fi
  if [[ 1 -eq $error ]]; then
    exit $error
  fi

  for path in $(pwd)/* ; do
    if [[ -d $path ]]; then
      curdir=$(dirname $(readlink -f "$path/install.sh"))
      if [[ -r $path/check_dependence.sh ]]; then
        . $path/check_dependence.sh
      fi
      unset curdir
    fi
  done
fi
# }

# do_install {
if [[ 1 -eq $do_install ]]; then
  echo '正在安装配置文件...'
  for path in $(pwd)/* ; do
    if [[ -d $path ]]; then
      curdir=$(dirname $(readlink -f "$path/install.sh"))
      if [[ -r $path/install.sh ]]; then
        . $path/install.sh
      fi
      unset curdir
    fi
  done
fi
# }

# do_dependence {
if [[ 1 -eq $do_dependence ]]; then
  echo '正在安装所需依赖...'
  for path in $(pwd)/* ; do
    if [[ -d $path ]]; then
      curdir=$(dirname $(readlink -f "$path/install.sh"))
      if [[ -r $path/install_dependence.sh ]]; then
        . $path/install_dependence.sh
      fi
      unset curdir
    fi
  done
fi
# }

