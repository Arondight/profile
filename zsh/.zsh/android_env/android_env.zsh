#!/usr/bin/env zsh

# ======================== #
# repo 函数                #
#                          #
#             By 秦凡东    #
# ======================== #
function repo {
  local LC_ALL_bak=$LC_ALL

  export LC_ALL=''

  command env repo $*

  export LC_ALL=$LC_ALL_bak
}

# ======================== #
# android_env 函数         #
# 用于快速切换到           #
# Android 开发环境         #
#                          #
#             By 秦凡东    #
# ======================== #
function android_env {
  local env_script=''

  # 基本环境检查 {
  virtualenv_failed=0
  if ! whereis virtualenvwrapper.sh >/dev/null 2>&1; then
    virtualenv_failed=1
  else
    env_script=$(whereis virtualenvwrapper.sh | awk '{print $2}')
    if [[ -d $env_script && -e $env_script/virtualenvwrapper.sh ]]; then
        env_script=$env_script/virtualenvwrapper.sh
    fi
    if [[ ! -e $env_script ]]; then
        virtualenv_failed=1
    fi
  fi

  if [[ 1 ==  $virtualenv_failed ]]; then
    echo "EE: 未发现python-virtualenvwrapper"
    return 1
  fi

  if ! type python2 >/dev/null 2>&1; then
    echo "EE: 未发现python2"
    return 1
  fi

  if ! type python3 >/dev/null 2>&1; then
    echo "EE: 未发现python3"
    return 1
  fi

  if ! type perl >/dev/null 2>&1; then
    echo "EE: 未发现perl"
    return 1
  fi
  # }

  # 本代码段在zsh 中运行
  if ! echo $0 | grep -P 'bash' >/dev/null 2>&1; then
    local interface="$HOME/.bash/interface"
    local android_env_interface="$interface/android_env.sh"

    echo "设置$(basename $SHELL) -> bash"

    if [[ ! -d $interface ]]; then
      mkdir -p $interface
    fi

    which repo > $android_env_interface
    which android_env >> $android_env_interface
    echo android_env >> $android_env_interface

    /usr/bin/env bash --init-file $android_env_interface

    rm -f $android_env_interface

    return $?
  fi
  # }

  # 本代码段在bash 中运行 {
  echo '设置python -> python2'
  export VIRTUALENVWRAPPER_PYTHON=$(which python)
  source $env_script
  if [[ ! -d "$WORKON_HOME/python2" ]]; then
    mkvirtualenv -p $(which python2) python2
  fi
  workon 'python2'

  echo '设置LC_ALL=C'
  export LC_ALL=C

  echo '设置LANG=en_US.UTF-8'
  export LANG=en_US.UTF-8

  echo '剔除$PATH 中的当前目录和重复项'
  export PATH=$(
    echo $PATH | perl -anF/:/ -E \
      'print join ":", grep { ! /^\.$/ } grep { ++$_{$_} < 2 } @F'
  )
  # }

  return $?
}

