#!/usr/bin/env bash
# ==============================================================================
# Do init for profiles of vim
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

PLUGINDIR="${HOME}/.vim/bundle"

# vim plugins
function preinit ()
{
  mkdir -p $PLUGINDIR

  return 0
}

# Vundel.vim
function initPlugins ()
{
  local VUNDLEDIR="${PLUGINDIR}/Vundle.vim"
  local VUNDLEURL='https://github.com/gmarik/Vundle.vim.git'

  if [[ ! -d ${VUNDLEDIR} ]]
  then
    if ! git clone $VUNDLEURL $VUNDLEDIR
    then
      return 1
    fi
  fi

  vim -c 'PluginUpdate' -c 'qa'

  return $?
}


# vimproc.vim
function initVimproc ()
{
  local VIMPROCDIR="${PLUGINDIR}/vimproc.vim"

  if [[ -d $VIMPROCDIR ]]
  then
    pushd $VIMPROCDIR
    make -j4
    popd
    return $?
  fi

  return 0
}

# color_coded
function initColorCoded ()
{
  local COLORCODEDDIR="${PLUGINDIR}/color_coded"

  if [[ -d $COLORCODEDDIR ]]
  then
    mkdir -p "${COLORCODEDDIR}/build"
    pushd "${COLORCODEDDIR}/build"
    cmake ..
    cmake --build . --target install --config Release -- -j4
    popd

    return $?
  fi

  return 0
}

# libtinfo
# XXX: This for a bug of YCM -- It use libtinfo.so but not provides by Arch Linux
function initLibtinfo ()
{
  local ANDROIDENVINIT_SH="$HOME/.zsh/android_env/init.sh"

  # This is ok, because installtion is before init
  if [[ -x $ANDROIDENVINIT_SH ]]; then
    command $ANDROIDENVINIT_SH

    return $?
  fi

  return 1
}

function initSyntastic ()
{
  local KDIR="/usr/lib/modules/$(uname -r)/build"
  local SYNTASTICDIR="$(dirname $(readlink -f $0))/syntastic"
  local SYNTASTIC_C_CONFIG="${HOME}/.syntastic_c_config"

  if [[ ! -d $KDIR ]]
  then
    return
  fi

  echo $SYNTASTICDIR
  pushd $SYNTASTICDIR
  make clean
  make all V=1 2>&1 | grep -oP -- '-nostdinc.+?(?=-DKBUILD_BASENAME)' | \
    head -n 1 |  tee $SYNTASTIC_C_CONFIG
  make clean
  sed -i 's/[ \t]\+/\n/g' $SYNTASTIC_C_CONFIG
  sed -i '/^\s*$/d' $SYNTASTIC_C_CONFIG
  popd
}

# YCM
function initYCM ()
{
  local YCMDIR="${PLUGINDIR}/YouCompleteMe"
  local LIBCLANG_SO='/usr/lib/libclang.so'
  local sysclang=0
  local buildpara=''
  local clangroot=''

  if [[ -d $YCMDIR ]]
  then
    buildpara="--clang-completer"
    clangroot=$(find $HOME/.vim/bundle/color_coded/build -maxdepth 1 -type d -name 'clang*' | sort -r | head -n 1)

    if [[ -z $clangroot && -e $LIBCLANG_SO ]]
    then
      sysclang=1
    fi

    if type go >/dev/null 2>&1
    then
      buildpara="$buildpara --gocode-completer"
    fi

    if type xbuild >/dev/null 2>&1
    then
      buildpara="$buildpara --omnisharp-completer"
    fi

    if type rustc >/dev/null 2>&1
    then
      buildpara="$buildpara --racer-completer"
    fi

    if type npm >/dev/null 2>&1 && type node >/dev/null 2>&1
    then
      buildpara="$buildpara --tern-completer"
    fi

    pushd $YCMDIR

    if ! git submodule update --init --recursive
    then
      return 1
    fi

    if [[ 1 -eq $sysclang ]]
    then
      buildpara="$buildpara --system-libclang"
      python2 "${YCMDIR}/install.py" $buildpara
      return $?
    elif [[ -n $clangroot ]]
    then
      mkdir -p ${YCMDIR}/build && \
        pushd ${YCMDIR}/build && \
        cmake -DPATH_TO_LLVM_ROOT=$clangroot . ${YCMDIR}/third_party/ycmd/cpp && \
        cmake --build . --target ycm_core --config Release && \
        popd
      return $?
    else
      python2 "${YCMDIR}/install.py" $buildpara
      return $?
    fi

    popd
  fi

  return 0
}

# MAIN:
{
  preinit || exit $?

  echo -ne "Init profiles for vim ...\t"

  initPlugins || exit $?
  initVimproc
  initColorCoded
  initLibtinfo
  initSyntastic
  initYCM

  echo 'done'

  exit 0
}

