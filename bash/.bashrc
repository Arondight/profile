# ==============================================================================
# bash 配置文件
# ==============================================================================
# 位置: ~/.zshrc
#
#           By 秦凡东
# ==============================================================================

# ==============================================================================
# Prompt
# ==============================================================================
GIT_PROMPT_ONLY_IN_REPO=0
GIT_PROMPT_FETCH_REMOTE_STATUS=1
GIT_PROMPT_SHOW_UPSTREAM=1
#GIT_PROMPT_STATUS_COMMAND=gitstatus_pre-1.7.10.sh
# as last entry source the gitprompt script
GIT_PROMPT_THEME=Default
if [[ -r $HOME/.bash/bash-git-prompt/gitprompt.sh ]]; then
  source $HOME/.bash/bash-git-prompt/gitprompt.sh
fi

# ==============================================================================
# 加载自定义函数
# ==============================================================================
source $HOME/.zsh/reactor.sh

