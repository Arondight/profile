
# ==============================================================================
# 更新配置文件
# ==============================================================================
alias profile-update='profileupdate'
alias profile_update='profileupdate'

function profileupdate () {
  local _profileroot=$(dirname $(dirname $(readlink -f "${HOME}/.zshrc")))
  local _upstream='https://github.com/Arondight/profile.git'
  local _urlreg='https?://(([\w\d\.-]+\.\w{2,6})|(\d{1,3}(\.\d{1,3}){3}))(:\d{1,4})*(/[\w\d\&%\./-~-]*)?'
  local _branch='master'
  local _gitconf=''
  local _giturl=''

  pushd "$_profileroot"

  if existcmd 'groot'
  then
    groot
  fi

  _profileroot="$(pwd)"
  _gitconf="${_profileroot}/.git/config"

  if [[ -r "$_gitconf" ]]
  then
    _giturl=$(grep -oP "$_urlreg" "$_gitconf" | head -n 1)
  fi

  if [[ '-f' == "$1" ]]
  then
    git reset HEAD .
    git checkout -- .
  fi

  _giturl="${_giturl:-$_upstream}"

  if git pull --rebase --stat "$_giturl" "$_branch"
  then
    echo 'Everything is up to date. Run "profilereconf" to reconfig.'
  else
    echo 'Failed to update, maybe your git repo is dirty.' >&2
    echo 'Use "-f" option to do a force update, but you will lose local changes.' >&2
  fi

  popd

  return "$?"
}

