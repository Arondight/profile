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
  ZSHSUGGESTDIR="${PLUGINDIR}/zsh-autosuggestions"
  ZSHSUGGESTURL='https://github.com/zsh-users/zsh-autosuggestions.git'
  GITPULLCMD='git pull --rebase --stat'

  echo 'Init profiles for zsh ...'

  # oh-my-zsh
  if [[ ! -d $OHMYZSHDIR ]]
  then
    git clone $OHMYZSHURL $OHMYZSHDIR
  else
    pushd $OHMYZSHDIR && command $GITPULLCMD && popd
  fi

  # zsh-syntax-highlighting
  if [[ ! -d $ZSHSYNHLDIR ]]
  then
    git clone $ZSHSYNHLURL $ZSHSYNHLDIR
  else
    pushd $ZSHSYNHLDIR && command $GITPULLCMD && popd
  fi

  # zsh-completions
  if [[ ! -d $ZSHCOMLDIR ]]
  then
    git clone $ZSHCOMLURL $ZSHCOMLDIR
  else
    pushd $ZSHCOMLDIR && command $GITPULLCMD && popd
  fi

  # zsh-autosuggestions
  if [[ ! -d $ZSHSUGGESTDIR ]]
  then
    git clone $ZSHSUGGESTURL $ZSHSUGGESTDIR
  else
    pushd $ZSHSUGGESTDIR && command $GITPULLCMD && popd
  fi

  # for possible insecure directories
  chmod g-w -R $OHMYZSHDIR

  echo 'done'

  exit $?
}

