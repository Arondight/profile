#!/usr/bin/env zsh
# ======================== #
# rubygems binary path     #
#                          #
#             By 秦凡东    #
# ======================== #

if [[ -s /usr/bin/gem ]]; then
  path+=$(ruby -rubygems -e 'puts Gem.user_dir')/bin
fi

