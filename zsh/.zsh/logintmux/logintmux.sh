#!/usr/bin/env cat
# ==============================================================================
# login tmux，适用于无法分屏的ssh 的环境
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

# ==============================================================================
# 保持各终端tmux 的一致性
# ==============================================================================
function synctmux ()
{
  local SESSIONID='autotmux'

  if ! type tmux >/dev/null 2>&1
  then
    return 1
  fi

  if [[ -z "$TMUX" ]]
  then
    export TERM='xterm-256color'
    if ! tmux attach
    then
      if tmux -2 new -s $SESSIONID
      then
        exit $?
      fi
    fi
  fi

  return $?
}

# ==============================================================================
# 无视各终端tmux 的一致性
# ==============================================================================
function nosynctmux ()
{
  if ! type tmux >/dev/null 2>&1
  then
    return 1
  fi

  if [[ -z "$TMUX" ]]
  then
    export TERM='xterm-256color'
    if tmux -2 new
    then
      exit $?
    fi
  fi

  return $?
}

# ==============================================================================
# login tmux，取代login shell
# ==============================================================================
# 这个函数应该在login shell 的配置文件中被调用
function loginTmux ()
{
  local choose='n'

  if [[ -z $SSH_CLIENT || -n $TMUX ]]
  then
    return 0
  fi

  echo -n 'It seems you login with a ssh client, work with tmux? (y/n) '
  read choose

  if [[ $choose =~ '[^yY]' ]]
  then
    return 0
  fi

  cat <<'EOF'
How do you want to use tmux?
  (1) Try to attach a common session, so operations are synchronized display.
  (2) Use a different session.
  (3) I do not want to use tmux anymore.
EOF

  while true
  do
    echo -n 'Choose one: '
    read choose

    if [[ $choose =~ '^[^0-9]+$' ]]
    then
      continue
    fi

    if [[ 'false' == $(awk --assign=choose=$choose \
                        'BEGIN { print ((choose >= 1) && (choose < 4)) \
                          ? "true" : "false" }') ]]
    then
      continue
    fi
    break
  done

  case $choose in
    1)
      synctmux
      ;;
    2)
      nosynctmux
      ;;
    3)
      ;;
    *)
      return 1
      ;;
  esac

  return 0
}

