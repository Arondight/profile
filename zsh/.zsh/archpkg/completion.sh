#!/usr/bin/env cat
# shellcheck shell=bash
# ==============================================================================
# archpkg 补全（zsh + bash 通用）
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================
# 本文件由 loader.sh 自动 source。两个补全函数都定义，但只在注册时
# 按 shell 区分：zsh 用 compdef，bash 用 complete -F。
# ==============================================================================

# ==============================================================================
# 共享辅助函数（两种 shell 都能运行）
# ==============================================================================
function _archpkg_available_pkgs ()
{
  if existcmd 'pacman'
  then
    pacman -Slq 2>/dev/null
  fi
  return 0
}

function _archpkg_installed_pkgs ()
{
  if existcmd 'pacman'
  then
    pacman -Qq 2>/dev/null
  fi
  return 0
}

# ==============================================================================
# 补全函数定义
# ==============================================================================
# zsh 端：compdef 注册后，按 TAB 时由 zsh 调用
function _profile_archpkg ()
{
  local -a options
  local -a packages

  _arguments -C \
    '1: :->subcmd' \
    '*:: :->args'

  case "$state" in
    subcmd)
      options=(
        'update:Update repos'
        'check-updates:Check for available updates'
        'upgrade-all:Upgrade all packages'
        'clean-system:Clean useless packages and cached files'
        'install:Install a package'
        'reinstall:Reinstall a package'
        'remove:Remove a package'
        'download:Download a package without installing'
        'info:Show package information'
        'search:Search for a package'
        'file-search:Find which package provides a file'
        'generate-template:Export installed package list to a template'
        'install-template:Install all packages from a template'
        'remove-template:Remove all packages from a template'
        'help:Show help message'
      )
      _describe 'archpkg' options
      ;;
    args)
      case "$line[1]" in
        install|reinstall|download|info|search)
          packages=(${(f)"$(_archpkg_available_pkgs)"})
          _wanted packages expl 'package' compadd -a packages
          ;;
        remove|check-updates)
          packages=(${(f)"$(_archpkg_installed_pkgs)"})
          _wanted packages expl 'package' compadd -a packages
          ;;
        generate-template|install-template|remove-template)
          _files
          ;;
      esac
      ;;
  esac
}

# bash 端：complete -F 注册后，按 TAB 时由 bash 调用
function _profile_archpkg_bash ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local cmd=''
  local subcommands='
    update check-updates upgrade-all clean-system install reinstall remove
    download info search file-search generate-template install-template
    remove-template help
  '

  if [[ $COMP_CWORD -ge 1 ]]
  then
    cmd="${COMP_WORDS[1]}"
  fi

  if [[ $COMP_CWORD -eq 1 ]]
  then
    COMPREPLY=($(compgen -W "$subcommands" -- "$cur"))
    return 0
  fi

  case "$cmd" in
    install|reinstall|download|info|search)
      COMPREPLY=($(compgen -W "$(_archpkg_available_pkgs)" -- "$cur"))
      ;;
    remove|check-updates)
      COMPREPLY=($(compgen -W "$(_archpkg_installed_pkgs)" -- "$cur"))
      ;;
    generate-template|install-template|remove-template)
      COMPREPLY=($(compgen -f -- "$cur"))
      ;;
  esac

  return 0
}

# ==============================================================================
# 注册（按 shell 区分）
# ==============================================================================
if [[ -n "$ZSH_NAME" ]]
then
  compdef _profile_archpkg archpkg
else
  complete -F _profile_archpkg_bash archpkg
fi
