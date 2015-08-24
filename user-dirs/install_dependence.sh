#!/usr/bin/env bash

perl -MFile::Path -MEnv -nE '/^\w+="(.+)"/ and eval "mkpath \"$1\""' <$HOME/.config/user-dirs.dirs

