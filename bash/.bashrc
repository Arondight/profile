# ==============================================================================
# bash 配置文件
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================

# ==============================================================================
# Common
# ==============================================================================
HISTCONTROL='ignoredups:ignorespace'
HISTSIZE=65536
HISTFILESIZE=655360
shopt -s 'histappend'
shopt -s 'checkwinsize'

# ==============================================================================
# 环境变量
# ==============================================================================
# For gpg2
export GPG_TTY="$TTY"

# ==============================================================================
# Prompt
# ==============================================================================
if [[ -r "${HOME}/.bash/bash-git-prompt/gitprompt.sh" ]]
then
  GIT_PROMPT_ONLY_IN_REPO=0
  GIT_PROMPT_FETCH_REMOTE_STATUS=1
  GIT_PROMPT_SHOW_UPSTREAM=1
  #GIT_PROMPT_STATUS_COMMAND=gitstatus_pre-1.7.10.sh
  # as last entry source the gitprompt script
  GIT_PROMPT_THEME='Default'
  source "${HOME}/.bash/bash-git-prompt/gitprompt.sh"
fi

# ==============================================================================
# 补全
# ==============================================================================
if [[ -r '/usr/share/bash-completion/bash_completion' ]]
then
  source '/usr/share/bash-completion/bash_completion'
fi

# ==============================================================================
# 加载自定义函数
# ==============================================================================
if [[ -r "${HOME}/.zsh/reactor.sh" ]]
then
  source "${HOME}/.zsh/reactor.sh"
fi

