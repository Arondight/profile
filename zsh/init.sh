#!/usr/bin/env bash
# ==============================================================================
# Do init for profiles of zsh
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

# MAIN:
{
  OHMYZSHDIR="${HOME}/.oh-my-zsh"
  OHMYZSHURL='https://github.com/robbyrussell/oh-my-zsh.git'
  PLUGINDIR="${OHMYZSHDIR}/custom/plugins"
  ZSHSYNHLDIR="${PLUGINDIR}/zsh-syntax-highlighting"
  ZSHSYNHLURL='https://github.com/zsh-users/zsh-syntax-highlighting.git'
  ZSHCOMLDIR="${PLUGINDIR}/zsh-completions"
  ZSHCOMLURL="https://github.com/zsh-users/zsh-completions.git"

  echo -ne "Init profiles for zsh ...\t"

  # oh-my-zsh
  if [[ ! -d $OHMYZSHDIR ]];then
    git clone $OHMYZSHURL $OHMYZSHDIR
  fi

  # zsh-syntax-highlighting
  if [[ ! -d $ZSHSYNHLDIR ]];then
    git clone $ZSHSYNHLURL $ZSHSYNHLDIR
  fi

  # zsh-completions
  if [[ ! -d $ZSHCOMLDIR ]]; then
    git clone $ZSHCOMLURL $ZSHCOMLDIR
  fi

  # for possible insecure directories
  chmod g-w -R $OHMYZSHDIR

  echo 'done'

  exit $?
}

