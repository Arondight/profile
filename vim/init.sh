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
  mkdir -p "$PLUGINDIR"

  return 0
}

# Vundel.vim
function initPlugins ()
{
  local VUNDLEDIR="${PLUGINDIR}/Vundle.vim"
  local VUNDLEURL='https://github.com/VundleVim/Vundle.vim.git'

  if [[ ! -d ${VUNDLEDIR} ]]
  then
    if ! git clone "$VUNDLEURL" "$VUNDLEDIR"
    then
      return 1
    fi
  fi

  vim -c 'PluginUpdate' -c 'qa'
  vim -c 'PluginClean!' -c 'qa'

  return $?
}


# vimproc.vim
# shellcheck disable=SC2317
function initVimproc ()
{
  local VIMPROCDIR="${PLUGINDIR}/vimproc.vim"

  if [[ -d $VIMPROCDIR ]]
  then
    pushd "$VIMPROCDIR" || exit
    {
      make -j8
    }
    popd || exit
    return $?
  fi

  return 0
}

# clang_complete
# shellcheck disable=SC2317
function initClangComplete ()
{
  local _clang_complete_dir="${PLUGINDIR}/clang_complete"

  if [[ -d "$_clang_complete_dir" ]]
  then
    pushd "$_clang_complete_dir" || exit
    {
      make install -j8
    }
    popd || exit
    return $?
  fi

  return 0
}

# vim-go
function initVimGo ()
{
  local _vim_go_dir="${PLUGINDIR}/vim-go"

  if [[ -d "$_vim_go_dir" ]]
  then
    vim -c 'GoInstallBinaries' -c 'qa'
  fi

  return 0
}

# color_coded
# shellcheck disable=SC2317
function initColorCoded ()
{
  local COLORCODEDDIR="${PLUGINDIR}/color_coded"

  if [[ -d "$COLORCODEDDIR" ]]
  then
    mkdir -p "${COLORCODEDDIR}/build"
    pushd "${COLORCODEDDIR}/build" || exit
    {
      cmake ..
      cmake --build . --target install --config Release -- -j8
    }
    popd || exit

    return $?
  fi

  return 0
}

# libtinfo
# XXX: This for a bug of YCM -- It use libtinfo.so but not provides by Arch Linux
# shellcheck disable=SC2317
function initLibtinfo ()
{
  local ANDROIDENVINIT_SH="$HOME/.zsh/android_env/init.sh"

  # This is ok, because installtion is before init
  if [[ -x "$ANDROIDENVINIT_SH" ]]; then
    command "$ANDROIDENVINIT_SH"

    return $?
  fi

  return 1
}

# shellcheck disable=SC2317
function initSyntastic ()
{
  local KDIR
  KDIR="/usr/lib/modules/$(uname -r)/build"
  local SYNTASTICDIR
  SYNTASTICDIR="$(dirname "$(readlink -f "$0")")/syntastic"
  local SYNTASTIC_C_CONFIG="${HOME}/.syntastic_c_config"

  if [[ ! -d "$KDIR" ]]
  then
    return
  fi

  echo "$SYNTASTICDIR"
  pushd "$SYNTASTICDIR" || exit
  {
    make clean
    make all V=1 2>&1 | grep -oP -- '-nostdinc.+?(?=-DKBUILD_BASENAME)' | \
      head -n 1 |  tee "$SYNTASTIC_C_CONFIG"
    make clean
    sed -i 's/[ \t]\+/\n/g' "$SYNTASTIC_C_CONFIG"
    sed -i '/^\s*$/d' "$SYNTASTIC_C_CONFIG"
  }
  popd || exit
}

# YCM
# shellcheck disable=SC2317
# Updated per https://ycm-core.github.io/YouCompleteMe/
# clangd-based (replaces old libclang/color_coded path), requires Python 3.12+
function initYCM ()
{
  local YCMDIR="${PLUGINDIR}/YouCompleteMe"
  local _ret=0
  local -a buildpara=()

  if [[ ! -d "$YCMDIR" ]]
  then
    return 0
  fi

  # C-family: clangd is the modern completer; install.py downloads a pre-built binary
  buildpara+=('--clangd-completer')

  # Go (gopls)
  if type go >/dev/null 2>&1
  then
    buildpara+=('--go-completer')
  fi

  # C# (OmniSharp-Roslyn, requires Mono)
  if type mono >/dev/null 2>&1
  then
    buildpara+=('--cs-completer')
  fi

  # JavaScript/TypeScript (TSServer, requires Node.js 18+ and npm)
  if type npm >/dev/null 2>&1 && type node >/dev/null 2>&1
  then
    buildpara+=('--ts-completer')
  fi

  # Rust (rust-analyzer)
  if type rustc >/dev/null 2>&1
  then
    buildpara+=('--rust-completer')
  fi

  # Java (jdt.ls, requires JDK 17+)
  if type java >/dev/null 2>&1
  then
    buildpara+=('--java-completer')
  fi

  pushd "$YCMDIR" || exit
  {
    if ! git submodule update --init --recursive
    then
      _ret=1
    else
      python3 "${YCMDIR}/install.py" "${buildpara[@]}"
      _ret=$?
    fi
  }
  popd || exit

  return "$_ret"
}

function initVimLsp ()
{
  local VIMLSP="${PLUGINDIR}/vim-lsp"

  if [[ -d $VIMLSP ]]
  then
    vim -c 'LspInstallServer' -c 'qa'
    return $?
  fi

  return 0
}

# MAIN:
{
  preinit || exit $?

  echo -ne "Init profiles for vim ...\t"

  initPlugins || exit $?
  #initVimproc
  #initClangComplete
  #initVimGo
  #initColorCoded
  #initLibtinfo
  #initSyntastic
  #initYCM
  initVimLsp

  echo 'done'

  exit 0
}

