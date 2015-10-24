#!/usr/bin/env bash

# oh-my-fish
if type curl >/dev/null 2>&1 && [[ -x /usr/bin/fish ]]; then
  curl -L github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish
fi

