#!/usr/bin/env zsh

alias ssh-env='ssh_env'

# ==============================================================================
# ssh 密钥管理器
#
#                 by 秦凡东
# ==============================================================================
function ssh_env {
  local list=''

  if [[ -z $SSH_ENV_WORK_DIR ]]; then
    export SSH_ENV_WORK_DIR="$HOME/.ssh_env"
  fi

  if [[ ! -e $SSH_ENV_WORK_DIR ]]; then
    mkdir -p $SSH_ENV_WORK_DIR
  fi

  if [[ ! -d $SSH_ENV_WORK_DIR || ! -w $SSH_ENV_WORK_DIR ]]; then
    echo "环境目录\"$SSH_ENV_WORK_DIR\"不正确。"
    return 1
  fi

  if [[ 0 == $# ]]; then
    set -- "help"
  fi

  if [[ ! -L "$HOME/.ssh" && -e "$HOME/.ssh" ]]; then
    local suffix=$(date +%s)
    mv "$HOME/.ssh" "$SSH_ENV_WORK_DIR/ssh.$suffix"
    echo "当前密钥已转化为\"ssh.$suffix\"。"
    set -- "use" "ssh.$suffix"
  fi

  while true; do
    case "$1" in
      show)
        shift
        set -- "list"
        ;;
      list)
        shift
        local current=$(readlink -f "$HOME/.ssh")
        for file in $SSH_ENV_WORK_DIR/*; do
          if [[ -d $file && -w $file ]]; then
            echo -n "$(basename $file)"
            if [[ $file == $current ]]; then
              echo "\t*"
            else
              echo
            fi
          fi
          unset file
        done
        return $?
        ;;
      use)
        shift
        set -- "workon" $@
        ;;
      workon)
        shift
        env=$1
        shift
        env=$SSH_ENV_WORK_DIR/$env
        if [[ -d $env && -r $env ]]; then
          echo "切换到\"$(basename $env)\""
          if [[ -e $HOME/.ssh ]]; then
            rm -rf $HOME/.ssh
          fi
          ln -sf $env $HOME/.ssh
          return $?
        else
          echo "环境\"$env\"不存在或不可读。"
          return 1
        fi
        return 0
        ;;
      new)
        shift
        set -- "create" $@
        ;;
      create)
        shift
        if ! type ssh-keygen >/dev/null 2>&1; then
          echo "未发现指令\"ssh-keygen\""
          return 1
        fi
        local new=$1
        shift
        if [[ -d $SSH_ENV_WORK_DIR/$new ]]; then
          echo "环境\"$new\"已经存在。"
          return 1
        fi
        if [[ ! -L $HOME/.ssh && -e $HOME/.ssh ]]; then
          echo "\"$HOME/.ssh\"不为链接，请重新执行该指令。"
          return 1
        fi
        if [[ $# > 0 ]]; then
          local mail=$1
          shift
        fi
        if [[ -z $mail ]]; then
          mail="$(whoami)@$(hostname)"
        fi
        mkdir -p "$SSH_ENV_WORK_DIR/$new"
        ssh-keygen -t 'rsa' -C "$mail" -f "$SSH_ENV_WORK_DIR/$new/id_rsa"
        if [[ -d $HOME/.ssh ]]; then
          rm -rf $HOME/.ssh
        fi
        return $?
        ;;
      rm)
        shift
        set -- "delete" $@
        ;;
      delete)
        shift
        local env=$SSH_ENV_WORK_DIR/$1
        if [[ ! -d $env ]]; then
          echo "未发现环境\"$1\""
          return 1
        fi
        if ! type tar >/dev/null 2>&1; then
          echo "未发现指令\"tar\""
          return 1
        fi
        if ! type gzip >/dev/null 2>&1; then
          echo "未发现指令\"gzip\""
          return 1
        fi
        echo "导出\"$1.tar.gz\""
        tar -zcf "$1.tar.gz" \
            -C "$SSH_ENV_WORK_DIR" "$(basename $env)"
        echo "删除环境\"$1\""
        rm -rf $env
        if [[ ! -d $(readlink -f $HOME/.ssh) ]]; then
          rm -rf "$HOME/.ssh"
        fi
        return $?
        ;;
      rename)
        shift
        set -- "mv" $@
        ;;
      move)
        shift
        set -- "mv" $@
        ;;
      mv)
        shift
          if [[ ! -d $SSH_ENV_WORK_DIR/$1 ]]; then
            echo "环境\"$1\"不存在"
            return 1
          fi
          echo "\"$1\" -> \"$2\""
          mv "$SSH_ENV_WORK_DIR/$1" "$SSH_ENV_WORK_DIR/$2"
          if [[ $(readlink -f "$HOME/.ssh") != $SSH_ENV_WORK_DIR/$1 ]]; then
            return $?
          fi
          set -- "use" $2   # Use new env
        ;;
      export)
        shift
        local archive=$1
        shift
        if ! type tar >/dev/null 2>&1; then
          echo "未发现指令\"tar\""
          return 1
        fi
        if ! type gzip >/dev/null 2>&1; then
          echo "未发现指令\"gzip\""
          return 1
        fi
        echo "导出\"${archive}.tar.gz\""
        tar -zcf "${archive}.tar.gz" \
            -C "$(dirname $SSH_ENV_WORK_DIR)" "$(basename $SSH_ENV_WORK_DIR)"
        if [[ 0 == $? ]]; then
          echo "成功"
        else
          echo "失败"
        fi
        return $?
        ;;
      import)
        shift
        local archive=$1
        shift
        if ! type tar >/dev/null 2>&1; then
          echo "未发现指令\"tar\""
          return 1
        fi
        if ! type gzip >/dev/null 2>&1; then
          echo "未发现指令\"gzip\""
          return 1
        fi
        if [[ ! -e $archive ]]; then
          echo "未发现$archive，尝试${archive}.tar.gz。"
          archive="$archive.tar.gz"
          if [[ ! -e $archive ]]; then
            echo "未发现$archive。"
            return 1
          fi
        fi
        echo "导入\"$archive\""
        tar -zxf "$archive" -C "$(dirname $SSH_ENV_WORK_DIR)"
        if [[ 0 == $? ]]; then
          echo "成功"
        else
          echo "失败"
        fi
        return $?
        ;;
      h|help|-h|--help)
        shift
        cat <<EOF
ssh_env - ssh 密钥管理器

用法:
  ssh_env [选项] <环境>

选项:
  list                      列出所有可供选择的ssh 环境
  use [环境]                切换到ssh 环境
  new [环境] <邮箱>         创建一个新的ssh 环境
  delete [环境]             删除一个ssh 环境并提前创建备份
  rename [旧环境] [新环境]  将旧环境重命名为新环境
  export [文件]             将整个环境导出到归档
  import [文件]             从归档导入到环境
  help                      打印本帮助
EOF
        return 0
        ;;
      *)
        return 1
    esac
  done
}

