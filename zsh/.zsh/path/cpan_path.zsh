#!/usr/bin/env zsh
# ==============================================================================
# cpan path for user
#
#             By 秦凡东
# ==============================================================================

export PERL_LOCAL_LIB_ROOT="$HOME/lib/perl5"
export PERL5LIB="$PERL_LOCAL_LIB_ROOT/lib/perl5"
export PERL_MB_OPT="--install_base \"$PERL_LOCAL_LIB_ROOT\""
export PERL_MM_OPT="INSTALL_BASE=$PERL_LOCAL_LIB_ROOT"
export PATH="$PERL_LOCAL_LIB_ROOT/bin:$PATH"

