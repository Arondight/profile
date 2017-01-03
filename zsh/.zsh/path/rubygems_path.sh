#!/usr/bin/env cat
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

if existcmd gem
then
  export PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

