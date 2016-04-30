
# ==============================================================================
# 更新配置文件
# ==============================================================================
alias profile-update='profileupdate'
alias profile_update='profileupdate'

function profileupdate () {
  local PROFILEROOT=$(dirname $(dirname $(readlink -f $HOME/.zshrc)))
  local CWD=$(pwd)

  cd $PROFILEROOT
  if [[ '-f' == $1 ]]
  then
    git reset HEAD .
    git checkout -- .
  fi
  if git pull --rebase --stat https://github.com/Arondight/profile.git master
  then
    echo 'Everything is up to date. Run "profilereconf" to reconfig.'
  else
    echo 'Failed to update, maybe your git repo is dirty.'  \
         'use "-f" option to do a force update, but you will lose local changes.' \
         >&2
  fi

  cd $CWD

  return $?
}

