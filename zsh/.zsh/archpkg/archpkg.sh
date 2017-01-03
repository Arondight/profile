#!/usr/bin/env cat
# ==============================================================================
# A slackpkg-style package manager for Arch Linux
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

if [[ -n $ZSH_NAME ]]
then
  fpath+="${HOME}/.zsh/archpkg"
fi

function _archpkgHelp ()
{
  cat <<'END_OF_HELP' >&2
archpkg - A slackpkg-style package manager for Arch Linux

Usage:
  archpkg [option] <regex|file>

Options:
  update                      Update repos
  check-updates [package]     Check for update
  upgrade-all                 Upgrade all packages
  clean-system                Clean useless packages and cached files
  install <package>           Install a package
  reinstall <package>         Reinstall a package
  remove <package>            Remove a package
  download <package>          Download a package but do not install it
  info <package>              Show info of a package
  search <regex>              Search for package
  file-search <file>          Show which package provide the file
  generate-template <file>    Generate a template file contains all packages name
  install-template <file>     Install all packages from a template file
  remove-template <file>      Remove all packages from a template file
  help                        Show this help message

Example:
  archpkg upgrade-all
  archpkg file-search vim
  archpkg remove lib32-.+
END_OF_HELP

  return "$?"
}

function _archpkgCheckUpgrades ()
{
  sudo pacman -Qu $@

  return "$?"
}

function _archpkgUpdate ()
{
  sudo pacman -Sy

  if existcmd 'pkgfile'
  then
    sudo pkgfile --update
  fi

  return "$?"
}

function _archpkgUpgradeAll ()
{
  sudo pacman -Sy
  sudo pacman --needed --noconfirm --color auto -S xdelta3
  sudo pacman --noconfirm --color auto -Su
  sudo pacman --needed --noconfirm --color auto -S linux-headers

  if existcmd 'pkgfile'
  then
    sudo pkgfile --update
  fi

  return "$?"
}

function _archpkgCleanSystem ()
{
  local _result=( $(pacman -Qqdt) )

  if [[ 0 -ne "${#_result[@]}" ]]
  then
    sudo pacman --noconfirm --color auto -Rsn ${_result[@]}
  fi

  sudo pacman --noconfirm --color auto -Sc

  return "$?"
}

function _archpkgInstall ()
{
  if [[ 0 -eq "$#" ]]
  then
    _archpkgHelp
    return 1
  fi

  sudo pacman --needed --color auto -S $@

  return "$?"
}

function _archpkgReinstall ()
{
  if [[ 0 -eq "$#" ]]
  then
    _archpkgHelp
    return 1
  fi

  sudo pacman --color auto -S $@

  return "$?"
}

function _archpkgRemove ()
{
  local _result=''

  if [[ 0 -eq "$#" ]]
  then
    _archpkgHelp
    return 1
  fi

  _result=( $(pacman -Qqs "$1") )

  if [[ 0 != "${#_result[@]}" ]]
  then
    sudo pacman --color auto -Rsn ${_result[@]}
  fi

  return $?
}

function _archpkgDownload ()
{
  if [[ 0 -eq "$#" ]]
  then
    _archpkgHelp
    return 1
  fi

  sudo pacman --color auto -Sw $@

  return "$?"
}

function _archpkgInfo ()
{
  if [[ 0 -eq "$#" ]]
  then
    _archpkgHelp
    return 1
  fi

  pacman --color auto -Si $@

  return "$?"
}

function _archpkgSearch ()
{
  if [[ 0 -eq "$#" ]]
  then
    _archpkgHelp
    return 1
  fi

  pacman --color auto -Si $@

  return "$?"
}

function _archpkgFileSearch ()
{
  if [[ 0 -eq "$#" ]]
  then
    _archpkgHelp
    return 1
  fi

  if ! existcmd 'pkgfile'
  then
    sudo pacman --noconfirm --color auto -S pkgfile
    sudo pkgfile --update
  fi

  pkgfile --search $@

  return "$?"
}

function _archpkgGenerateTemplate ()
{
  local _templatefile=''
  local _packages=''

  if [[ 0 -eq "$#" ]]
  then
    _archpkgHelp
    return 1
  fi

  _templatefile=$(readlink -f "$1")

  _packages=$(pacman -Qqn)    # 这里不使用数组
  if [[ -e "$_templatefile" ]]
  then
    rm -f "$_templatefile"
  fi

  echo "$_packages" | sudo tee -a "$_templatefile" >/dev/null 2>&1

  return "$?"
}

function _archpkgInstallTemplate ()
{
  local _templatefile=''
  local _packages=''

  if [[ 0 -eq "$#" ]]
  then
    _archpkgHelp
    return 1
  fi

  _templatefile=$(readlink -f "$1")
  if [[ ! -e "$_templatefile" ]]
  then
    echo "File \"${_templatefile}\" not exists."
    return 1
  fi

  _packages=( $(cat "$_templatefile") )
  sudo pacman --needed --color auto -S ${_packages[@]}

  return "$?"
}

function _archpkgRemoveTemplate ()
{
  local _templatefile=''
  local _packages=''

  if [[ 0 -eq $# ]]
  then
    _archpkgHelp
    return 1
  fi

  _templatefile=$(readlink -f "$1")
  if [[ ! -e "$_templatefile" ]]
  then
    echo "File \"${_templatefile}\" not exists."
    return 1
  fi

  _packages=( $(cat "$_templatefile") )
  sudo pacman --color auto -Rsn ${_packages[@]}

  return "$?"
}

function archpkg ()
{
  if [[ 0 -eq "$#" ]]
  then
    set -- 'help'
  fi

  if ! existcmd 'pacman-key'
  then
    echo 'It seems that your system is not an Arch Linux like.'
    return 1
  fi

  case "$1" in
    check-updates)
      shift
      _archpkgCheckUpgrades
      ;;
    update)
      shift
      _archpkgUpdate
      ;;
    upgrade-all)
      shift
      _archpkgUpgradeAll
      ;;
    clean-system)
      shift
      _archpkgCleanSystem
      ;;
    install)
      shift
      _archpkgInstall $@
        ;;
    reinstall)
      shift
      _archpkgReinstall $@
      ;;
    remove)
      shift
      _archpkgRemove $@
      ;;
    download)
      shift
      _archpkgDownload $@
      ;;
    info)
      shift
      _archpkgInfo $@
      ;;
    search)
      shift
      _archpkgSearch $@
      ;;
    file-search)
      shift
      _archpkgFileSearch $@
      ;;
    generate-template)
      shift
      _archpkgGenerateTemplate $@
      ;;
    install-template)
      shift
      _archpkgInstallTemplate $@
      ;;
    remove-template)
      shift
      _archpkgRemoveTemplate $@
      ;;
    h|help|-h|--help)
      shift
      _archpkgHelp
      return 1
      ;;
    *)
      echo 'Run "archpkg -h" to show help message.' >&2
      return 1
  esac

  return "$?"
}

