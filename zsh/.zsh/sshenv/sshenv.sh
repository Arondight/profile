#!/usr/bin/env cat
# ==============================================================================
# ssh key manager
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================
# 由于历史原因，工作目录和指令名并不符合
export SSHENV_WORK_DIR=$(readlink -f ${SSHENV_WORK_DIR:-"${HOME}/.ssh_env"})

if [[ -n $ZSH_NAME ]]
then
  fpath+="${HOME}/.zsh/sshenv"
fi

alias ssh-env='sshenv'
alias ssh_env='sshenv'

function _sshenvHelp ()
{
  cat <<'EOF' >&2
sshenv - ssh key manager

Usage:
  ssh_env [options] <environment>

Options:
  list                        List all avaliable environments
  use [environment]           Use environment as default ssh key
  new [environment] <email>   Create a new environment with email if it is given
  delete [environment]        Export a environment then delete it
  rename [old] [new]          Rename old environment to new
  export [tarball]            Export all environments to a tarball
  import [tarball]            Import environments from a tarball
  help                        Show this help message
EOF

  return $?
}

function _sshenvProlog ()
{
  local SUFFIX=$(date +'%Y-%m-%d_%T')
  local SSHENV_SSH_DIR="${HOME}/.ssh"

  mkdir -p $SSHENV_WORK_DIR

  if [[ ! -d $SSHENV_WORK_DIR || ! -w $SSHENV_WORK_DIR ]]
  then
    echo "Can not open \"${SSHENV_WORK_DIR}\"." >&2
    return 1
  fi

  if [[ 0 -eq $# ]]
  then
    echo 'Run "sshenv -h" for help.' >&2
    return 1
  fi

  if [[ ! -L $SSHENV_SSH_DIR && -e $SSHENV_SSH_DIR ]]
  then
    if mv -f $SSHENV_SSH_DIR "${SSHENV_WORK_DIR}/env.${SUFFIX}"
    then
      echo "Transfer current ssh keys to environment \"env.${SUFFIX}\"."
    fi
  fi

  return $?
}

function _sshenvList ()
{
  # Here use origin path
  local SSHENV_SSH_DIR=$(readlink -f "${HOME}/.ssh")
  local env=''

  for env in $SSHENV_WORK_DIR/*
  do
    if [[ -d $env && -w $env ]]
    then
      echo -n "$(basename $env)"
      if [[ $env == $SSHENV_SSH_DIR ]]
      then
        echo -e "\t*"
      else
        echo
      fi
    fi
    unset env
  done

  return $?
}

function _sshenvUse ()
{
  local env="${SSHENV_WORK_DIR}/${1}"
  local ret=0

  if [[ -z $1 ]]
  then
    return 1
  fi

  if [[ -d $env && -r $env ]]
  then
    echo "Use environment \"$(basename $env)\"."
    if [[ -e $HOME/.ssh ]]
    then
      rm -rf $HOME/.ssh
    fi
    ln -sf $env $HOME/.ssh
    ret=$?
  else
    echo "Environment \"$env\" is bad." >&2
    ret=1
  fi

  return $ret
}

function _sshenvNew ()
{
  local new=$1
  local mail=${2:-"$(whoami)@$(hostname)"}

  if [[ -z $new ]]
  then
    return 1
  fi

  if ! type ssh-keygen >/dev/null 2>&1
  then
    echo "Command \"ssh-keygen\" not found." >&2
    return 1
  fi

  if [[ -d "${SSHENV_WORK_DIR}/${new}" ]]
  then
    echo "Environment \"$new\" has already exist." >&2
    return 1
  fi

  mkdir -p "${SSHENV_WORK_DIR}/${new}"
  ssh-keygen -t 'rsa' -C "$mail" -f "$SSHENV_WORK_DIR/$new/id_rsa"

  # XXX: WHY? I forgot why try to remove ~/.ssh here...
  if [[ -d $SSHENV_SSH_DIR ]]
  then
    rm -rf $SSHENV_SSH_DIR
  fi

  return $?
}

function _sshenvDelete ()
{
  local SSHENV_SSH_DIR="${HOME}/.ssh"
  local env="${SSHENV_WORK_DIR}/${1}"

  if [[ ! -d $env ]]
  then
    echo "Environment \"$1\" not found." >&2
    return 1
  fi

  if ! type tar >/dev/null 2>&1
  then
    echo "Command \"tar\" not found." >&2
    return 1
  fi

  if ! type gzip >/dev/null 2>&1
  then
    echo "Command \"gzip\" not found." >&2
    return 1
  fi

  echo "Export current environment \"${1}\" to \"${1}.tar.gz\""
  tar -zcf "${1}.tar.gz" -C $SSHENV_WORK_DIR $(basename $env)
  echo "Delete environment \"${1}\""
  rm -rf $env

  # XXX: WHY? I forgot why try to remove ~/.ssh here...
  if [[ -d $SSHENV_SSH_DIR ]]
  then
    rm -rf $SSHENV_SSH_DIR
  fi

  return $?
}

function _sshenvRename ()
{
  local old="${SSHENV_WORK_DIR}/${1}"
  local new="${SSHENV_WORK_DIR}/${2}"

  if [[ -z $old || -z $new ]]
  then
    echo 'Run "sshenv -h" for help.' >&2
    return 1
  fi

  if [[ ! -d $old ]]
  then
    echo "Environment \"${1}\" not found." >&2
    return 1
  fi

  echo "Rename \"$1\" to \"$2\"."
  mv $old $new
  _sshenvUse $2

  return $?
}

function _sshenvExport ()
{
  local tarball=$1

  if [[ -z $tarball ]]
  then
    echo 'Run "sshenv -h" for help.' >&2
    return 1
  fi

  if ! type tar >/dev/null 2>&1
  then
    echo "Command \"tar\" not found." >&2
    return 1
  fi

  if ! type gzip >/dev/null 2>&1
  then
    echo "Command \"gzip\" not found." >&2
    return 1
  fi

  echo "Export all environments to \"${tarball}.tar.gz\""
  tar -zcf "${tarball}.tar.gz" \
      -C "$(dirname $SSHENV_WORK_DIR)" "$(basename $SSHENV_WORK_DIR)"
  if [[ 0 -eq $? ]]
  then
    echo 'done'
  else
    echo 'failed' >&2
    return 1
  fi

  return 0
}

function _sshenvImport ()
{
  local tarball=$1

  if [[ -z $1 ]]
  then
    echo 'Run "sshenv -h" for help.' >&2
    return 1
  fi

  if ! type tar >/dev/null 2>&1
  then
    echo "Command \"tar\" not found." >&2
    return 1
  fi

  if ! type gzip >/dev/null 2>&1
  then
    echo "Command \"gzip\" not found." >&2
    return 1
  fi

  if [[ ! -r $tarball ]]
  then
    echo "Can not read \"${tarball}\", try \"${tarball}.tar.gz\"."
    tarball="${tarball}.tar.gz"
    if [[ ! -r $tarball ]]
    then
      echo "Can not read \"${tarball}\"" >&2
      return 1
    fi
  fi

  echo "Import environments from \"${tarball}\""
  tar -zxf "$tarball" -C "$(dirname $SSHENV_WORK_DIR)"
  if [[ 0 -eq $? ]]
  then
    echo 'done'
  else
    echo 'failed' >&2
    return 1
  fi

  return 0
}

function sshenv ()
{
  local list=''

  if ! _sshenvProlog $@
  then
    return 1
  fi

  case $1 in
    list|show)
      shift
      _sshenvList
      ;;
    use|workon)
      shift
      _sshenvUse $@
      ;;
    new|create)
      shift
      _sshenvNew $@
      ;;
    delete|remove|rm)
      shift
      _sshenvDelete $@
      ;;
    rename|move|mv)
      shift
      _sshenvRename $@
      ;;
    export)
      shift
      _sshenvExport $@
      ;;
    import)
      shift
      _sshenvImport $@
      ;;
    h|help|-h|--help)
      shift
      _sshenvHelp
      return 0
      ;;
    *)
      echo 'Run "sshenv -h" for help.' >&2
      return 1
      ;;
  esac

  return $?
}

