## alias

Shell aliases with safety defaults (e.g. `cp`/`mv`/`rm` prompt before overwrite, `ls` colorized, `grep` colorized with PCRE). When running under zsh, `global_alias.zsh` is also sourced: it clears any pre-existing global aliases and registers path-expansion globals (`..`, `...`, `....`, `.....`, `......`) so you can type `cd ...` to go up two levels.