#!/usr/bin/env bash
# ==============================================================================
# rubygems binary path
#
#             By 秦凡东
# ==============================================================================

if [[ -s /usr/bin/gem ]]; then
  export PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

