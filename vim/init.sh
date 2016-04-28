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

  vim -c 'PluginInstall' -c 'qa'

  return $?
}


# vimproc.vim
function initVimproc ()
{
  local VIMPROCDIR="${PLUGINDIR}/vimproc.vim"

  if [[ -d $VIMPROCDIR ]]
  then
    cd $VIMPROCDIR
    make -j4
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
    cd "${COLORCODEDDIR}/build"
    cmake ..
    cmake --build . --config Release -- install -j4

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
    clangroot=( $(find $HOME/.vim/bundle/color_coded/build -maxdepth 1 -type d -name 'clang*') )
    clangroot=${clangroot[-1]}

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

    cd $YCMDIR

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
        cd ${YCMDIR}/build && \
        cmake -DPATH_TO_LLVM_ROOT=$clangroot . ${YCMDIR}/third_party/ycmd/cpp && \
        cmake --build . --target ycm_core --config Release
      return $?
    else
      python2 "${YCMDIR}/install.py" $buildpara
      return $?
    fi
  fi

  return 0
}

# MAIN:
{
  preinit || exit $?

  echo -ne "Init profiles for vim ...\t"

  initPlugins || exit $?
  initVimproc || exit $?
  initColorCoded || exit $?
  initLibtinfo || exit $?
  initYCM || exit $?

  echo 'done'

  exit 0
}

