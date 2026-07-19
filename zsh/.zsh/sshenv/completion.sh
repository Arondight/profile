#!/usr/bin/env cat
# shellcheck shell=bash
# ==============================================================================
# sshenv 补全（zsh + bash 通用）
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
function _sshenv_environments ()
{
  local _work_dir="${SSHENV_WORK_DIR:-${HOME}/.ssh_env}"
  local _env=''
  if [[ -d "$_work_dir" ]]
  then
    for _env in "$_work_dir"/*
    do
      if [[ -d "$_env" ]]
      then
        basename "$_env"
      fi
    done
  fi
  return 0
}

# ==============================================================================
# 补全函数定义
# ==============================================================================
# zsh 端
function _profile_sshenv ()
{
  local -a options
  local -a envs

  _arguments -C \
    '1: :->subcmd' \
    '*:: :->args'

  case "$state" in
    subcmd)
      options=(
        'list:List all available environments'
        'use:Use environment as default ssh key'
        'new:Create a new environment with email if it is given'
        'delete:Export a environment then delete it'
        'rename:Rename old environment to new'
        'export:Export all environments to a tarball'
        'import:Import environments from a tarball'
        'help:Show this help message'
      )
      _describe 'sshenv' options
      ;;
    args)
      case "$line[1]" in
        use|delete)
          envs=(${(f)"$(_sshenv_environments)"})
          _wanted envs expl 'environment' compadd -a envs
          ;;
        rename)
          # rename <old> <new>：仅补全第一个参数（旧环境名），新名不应已有
          if [[ $CURRENT -eq 3 ]]
          then
            envs=(${(f)"$(_sshenv_environments)"})
            _wanted envs expl 'environment' compadd -a envs
          fi
          ;;
        import)
          _files -g '*.tar.gz'
          ;;
        export)
          # export 代码会在用户输入后追加 .tar.gz，所以补全普通文件而非 *.tar.gz
          _files
          ;;
      esac
      ;;
  esac
}

# bash 端
function _profile_sshenv_bash ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local cmd=''
  local subcommands='list use new delete rename export import help'

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
    use|delete|rename)
      # rename: 仅在补全第一个参数时列出已有环境（COMP_CWORD==2）
      if [[ "$cmd" == "rename" && $COMP_CWORD -gt 2 ]]
      then
        # 第二个参数是新名字，不补全已有环境
        COMPREPLY=()
        return 0
      fi
      COMPREPLY=($(compgen -W "$(_sshenv_environments)" -- "$cur"))
      ;;
    import)
      COMPREPLY=($(compgen -f -X '!*.tar.gz' -- "$cur"))
      ;;
    export)
      # export 代码会在用户输入后追加 .tar.gz，补全普通文件而非 *.tar.gz
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
  compdef _profile_sshenv sshenv ssh-env ssh_env
else
  complete -F _profile_sshenv_bash sshenv ssh-env ssh_env
fi
