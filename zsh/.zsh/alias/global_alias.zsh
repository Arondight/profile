#!/usr/bin/env zsh
# ======================== #
# alias                    #
#                          #
#             By 秦凡东    #
# ======================== #

# ======================== #
# disable any global alias #
# ======================== #
for alias in $(alias -g | grep -oP '^.+?(?==)'); do
  unalias $alias
done

# ======================== #
# safe global alias        #
# ======================== #
alias -g ....='../..'
alias -g ......='../../..'
alias -g ........='../../../..'
alias -g ..........='../../../../..'

