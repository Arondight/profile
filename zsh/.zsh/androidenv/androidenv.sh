#!/usr/bin/env cat
# ==============================================================================
# 切换到安卓开发环境
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

alias android-env='androidenv'
alias android_env='androidenv'

function repo ()
{
  local LC_ALL_bak="$LC_ALL"

  export LC_ALL=''
  # Here MUST be "env" not "command"
  env repo $*

  export LC_ALL="$LC_ALL_bak"

  return "$?"
}

function androidenv ()
{
  local WRAPPERSH='virtualenvwrapper.sh'
  local wrapper=''
  local failed=0

  # 基本环境检查
  # XXX: 这里考虑使用sed/awk 替换perl
  # {
  if [[ 0 -eq $(whereis "${WRAPPERSH}" | perl -anF/\\h/ -E 'say scalar @F - 1') ]]
  then
    failed=1
  else
    wrapper=$(whereis "${WRAPPERSH}" | awk '{print $2}')
    if [[ -d "$wrapper" && -e "${wrapper}/${WRAPPERSH}" ]]
    then
      wrapper="${wrapper}/${WRAPPERSH}"
    fi
    if [[ ! -e "$wrapper" ]]
    then
      failed=1
    fi
  fi

  if [[ 1 -eq "$failed" ]]
  then
    echo 'EE: python-virtualenvwrapper is needed but not found.'
    return 1
  fi

  if ! existcmd 'python2'
  then
    echo 'EE: python2 is needed but not found.'
    return 1
  fi

  if ! existcmd 'python3'
  then
    echo 'EE: python3 is needed but not found.'
    return 1
  fi

  if ! existcmd 'perl'
  then
    echo "EE: perl is needed but not found."
    return 1
  fi
  # }

  # 本代码段在zsh 中运行
  # {
  if [[ -n "$ZSH_NAME" ]]
  then
    local INTERFACEDIR="${HOME}/.bash/interface"
    local shadowscript="${INTERFACEDIR}/androidenv.sh"

    echo "set $(basename $SHELL) -> bash"

    mkdir -p "$INTERFACEDIR"

    which repo > "$shadowscript"
    which androidenv >> "$shadowscript"
    echo androidenv >> "$shadowscript"

    bash --init-file <(echo -e source \$HOME/.bashrc \&\& source "$shadowscript")

    rm -f "$shadowscript"

    return "$?"
  fi
  # }

  # 本代码段在bash 中运行
  # {
  echo 'set python -> python2'
  export VIRTUALENVWRAPPER_PYTHON="$(which python)"
  source "$wrapper"
  if [[ ! -d "${WORKON_HOME}/python2" ]]; then
    mkvirtualenv -p "$(which python2)" python2
  fi
  workon 'python2'

  echo 'export LC_ALL=C'
  export LC_ALL='C'

  echo 'export LANG=en_US.UTF-8'
  export LANG='en_US.UTF-8'

  echo 'unset PERL_MM_OPT'
  unset PERL_MM_OPT

  echo 'Excluding the current directory and duplicate entries of $PATH'
  # XXX: 考虑使用sed/awk 替换perl
  export PATH=$(
    echo $PATH | perl -anF/:/ -E \
      'print join ":", grep { ! /^\.$/ } grep { ++$_{$_} < 2 } @F'
  )
  # }

  return "$?"
}

