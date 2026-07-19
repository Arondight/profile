#!/usr/bin/env cat
# shellcheck shell=bash
# ==============================================================================
# ssh key manager
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================
# 由于历史原因，工作目录和指令名并不符合
SSHENV_WORK_DIR="$(readlink -f "${SSHENV_WORK_DIR:-"${HOME}/.ssh_env"}")"
export SSHENV_WORK_DIR

# 补全由 completion/completion.sh 统一提供，无需在此手动加入 fpath。

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

  return "$?"
}

function _sshenvProlog ()
{
  local _suffix
  _suffix="$(date +'%Y%m%d-%H%M%S')"
  local _sshenv_ssh_dir="${HOME}/.ssh"

  mkdir -p "$SSHENV_WORK_DIR"

  if [[ ! -d "$SSHENV_WORK_DIR" || ! -w "$SSHENV_WORK_DIR" ]]
  then
    echo "Can not open \"${SSHENV_WORK_DIR}\"." >&2
    return 1
  fi

  if [[ 0 -eq "$#" ]]
  then
    echo 'Run "sshenv -h" for help.' >&2
    return 1
  fi

  if [[ ! -L "$_sshenv_ssh_dir" && -e "$_sshenv_ssh_dir" ]]
  then
    if mv -f "$_sshenv_ssh_dir" "${SSHENV_WORK_DIR}/env.${_suffix}"
    then
      echo "Transfer current ssh keys to environment \"env.${_suffix}\"."
    else
      echo "Warning: failed to migrate existing ~/.ssh, continuing anyway." >&2
    fi
  fi

  return 0
}

function _sshenvList ()
{
  # Here use origin path
  local _sshenv_ssh_dir
  _sshenv_ssh_dir="$(readlink -f "${HOME}/.ssh")"
  local _env=''

  for _env in "$SSHENV_WORK_DIR"/*
  do
    if [[ -d "$_env" && -w "$_env" ]]
    then
      echo -n "$(basename "$_env")"
      if [[ "$_env" == "$_sshenv_ssh_dir" ]]
      then
        printf '\t*\n'
      else
        echo
      fi
    fi
    unset '_env'
  done

  return "$?"
}

function _sshenvUse ()
{
  local _env="${SSHENV_WORK_DIR}/${1}"
  local _ret=0

  if [[ -z "$1" ]]
  then
    return 1
  fi

  if [[ -d "$_env" && -r "$_env" ]]
  then
    echo "Use environment \"$(basename "$_env")\"."
    if [[ -e "${HOME}/.ssh" ]]
    then
      rm -rf "${HOME}/.ssh"
    fi
    ln -sf "$_env" "${HOME}/.ssh"
    _ret="$?"
  else
    echo "Environment \"${1}\" is bad." >&2
    _ret=1
  fi

  return "$_ret"
}

function _sshenvNew ()
{
  local _new="$1"
  local _mail="${2:-"$(whoami)@$(hostname)"}"

  if [[ -z "$_new" ]]
  then
    return 1
  fi

  if ! existcmd ssh-keygen
  then
    echo "Command \"ssh-keygen\" not found." >&2
    return 1
  fi

  if [[ -d "${SSHENV_WORK_DIR}/${_new}" ]]
  then
    echo "Environment \"${_new}\" has already exist." >&2
    return 1
  fi

  mkdir -p "${SSHENV_WORK_DIR}/${_new}"
  ssh-keygen -t 'ed25519' -C "${_mail}" -f "${SSHENV_WORK_DIR}/${_new}/id_ed25519"

  return "$?"
}

function _sshenvDelete ()
{
  local _sshenv_ssh_dir="${HOME}/.ssh"
  local _env="${SSHENV_WORK_DIR}/${1}"
  local _ret=0

  if [[ ! -d "$_env" ]]
  then
    echo "Environment \"$1\" not found." >&2
    return 1
  fi

  if ! existcmd 'tar'
  then
    echo "Command \"tar\" not found." >&2
    return 1
  fi

  if ! existcmd 'gzip'
  then
    echo "Command \"gzip\" not found." >&2
    return 1
  fi

  echo "Export current environment \"${1}\" to \"${1}.tar.gz\""
  if tar -zcf "${1}.tar.gz" -C "$SSHENV_WORK_DIR" "$(basename "$_env")"
  then
    echo "Delete environment \"${1}\""
    rm -rf "$_env"
    _ret="$?"
  else
    echo "Failed to export environment \"${1}\"." >&2
    return 1
  fi

  if [[ -L "$_sshenv_ssh_dir" && "$(readlink "$_sshenv_ssh_dir")" == "$_env" ]]
  then
    rm -rf "$_sshenv_ssh_dir"
  fi

  return "$_ret"
}

function _sshenvRename ()
{
  local _old="${SSHENV_WORK_DIR}/${1}"
  local _new="${SSHENV_WORK_DIR}/${2}"
  local _ret=0

  if [[ -z "$1" || -z "$2" ]]
  then
    echo 'Run "sshenv -h" for help.' >&2
    return 1
  fi

  if [[ ! -d "$_old" ]]
  then
    echo "Environment \"${1}\" not found." >&2
    return 1
  fi

  if [[ -d "$_new" ]]
  then
    echo "Environment \"${2}\" already exists." >&2
    return 1
  fi

  echo "Rename \"$1\" to \"$2\"."
  mv "$_old" "$_new"
  _ret="$?"

  if [[ 0 -eq "$_ret" ]]
  then
    _sshenvUse "$2"
  fi

  return "$_ret"
}

function _sshenvExport ()
{
  local _tarball="$1"

  if [[ -z "$_tarball" ]]
  then
    echo 'Run "sshenv -h" for help.' >&2
    return 1
  fi

  if ! existcmd 'tar'
  then
    echo "Command \"tar\" not found." >&2
    return 1
  fi

  if ! existcmd 'gzip'
  then
    echo "Command \"gzip\" not found." >&2
    return 1
  fi

  echo "Export all environments to \"${_tarball}.tar.gz\""
  if tar -zcf "${_tarball}.tar.gz" \
      -C "$(dirname "$SSHENV_WORK_DIR")" "$(basename "$SSHENV_WORK_DIR")"
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
  local _tarball="$1"

  if [[ -z "$_tarball" ]]
  then
    echo 'Run "sshenv -h" for help.' >&2
    return 1
  fi

  if ! existcmd 'tar'
  then
    echo "Command \"tar\" not found." >&2
    return 1
  fi

  if ! existcmd 'gzip'
  then
    echo "Command \"gzip\" not found." >&2
    return 1
  fi

  if [[ ! -r "$_tarball" ]]
  then
    echo "Can not read \"${_tarball}\", try \"${_tarball}.tar.gz\"."
    _tarball="${_tarball}.tar.gz"
    if [[ ! -r "$_tarball" ]]
    then
      echo "Can not read \"${_tarball}\"" >&2
      return 1
    fi
  fi

  echo "Import environments from \"${_tarball}\""
  if tar -zxf "$_tarball" -C "$(dirname "$SSHENV_WORK_DIR")"
  then
    echo 'done'
  else
    echo 'failed' >&2
    return 1
  fi

  # shellcheck disable=SC2044
  for d in $(find "${SSHENV_WORK_DIR}/"* -maxdepth 0 -type d)
  do
    command chmod 700 "$d"
  done

  # shellcheck disable=SC2044
  for f in $(find "${SSHENV_WORK_DIR}/" -type f -name 'id_*.pub')
  do
    command chmod 644 "$f"
  done

  # shellcheck disable=SC2044
  for f in $(find "${SSHENV_WORK_DIR}/" -type f -name 'id_*' -not -name '*.pub')
  do
    command chmod 400 "$f"
  done

  return 0
}

function sshenv ()
{
  if ! _sshenvProlog "$@"
  then
    return 1
  fi

  case "$1" in
    list|show)
      shift
      _sshenvList
      ;;
    use|workon)
      shift
      _sshenvUse "$@"
      ;;
    new|create)
      shift
      _sshenvNew "$@"
      ;;
    delete|remove|rm)
      shift
      _sshenvDelete "$@"
      ;;
    rename|move|mv)
      shift
      _sshenvRename "$@"
      ;;
    export)
      shift
      _sshenvExport "$@"
      ;;
    import)
      shift
      _sshenvImport "$@"
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

  return "$?"
}

