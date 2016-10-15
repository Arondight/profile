
# ==============================================================================
# 更新配置文件
# ==============================================================================
alias profile-update='profileupdate'
alias profile_update='profileupdate'

function profileupdate () {
  local PROFILEROOT=$(dirname $(dirname $(readlink -f $HOME/.zshrc)))
  local ORIGINGITURL='https://github.com/Arondight/profile.git'
  local URLREG='https?://(([\w\d\.-]+\.\w{2,6})|(\d{1,3}(\.\d{1,3}){3}))(:\d{1,4})*(/[\w\d\&%\./-~-]*)?'
  local BRANCH='master'
  local gitconf=''
  local giturl=''

  pushd $PROFILEROOT

  if type groot >/dev/null 2>&1
  then
    groot
  fi

  PROFILEROOT=$(pwd)

  gitconf="${PROFILEROOT}/.git/config"
  if [[ -r $gitconf ]]
  then
    giturl=$(grep -oP $URLREG $gitconf | head -n 1)
  fi

  if [[ '-f' == $1 ]]
  then
    git reset HEAD .
    git checkout -- .
  fi

  giturl=${giturl:-$ORIGINGITURL}

  if git pull --rebase --stat $giturl $BRANCH
  then
    echo 'Everything is up to date. Run "profilereconf" to reconfig.'
  else
    echo 'Failed to update, maybe your git repo is dirty.' >&2
    echo 'Use "-f" option to do a force update, but you will lose local changes.' >&2
  fi

  popd

  return $?
}

