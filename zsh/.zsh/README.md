## zsh

A shell plugin directory using bash syntax, compatible with any shell that supports bash syntax. Source it in your shell configuration:

```sh
source $HOME/.zsh/loader.sh
```

### Plugin rules

1. Register in the `myPluginLoader` function in `~/.zsh/loader.sh`
2. Logic must be suitable for sourcing in the current shell (not running as a standalone script)
3. File permissions must be readable and non-executable
4. Due to array indexing differences between zsh and bash/dash, plugins must not use array subscripts

### Completion convention

A plugin that needs tab completion ships a `completion.sh` file alongside its main script in the same directory. `loader.sh` already sources every readable, non-executable `*.sh` file in a plugin directory, so the completion file is picked up automatically — no registration needed.

Inside `completion.sh`, detect the shell with `[[ -n "$ZSH_NAME" ]]` and register the appropriate system:

- **zsh**: define a function and register it with `compdef <func> <command> [aliases...]`, using native zsh completion helpers (`_arguments`, `_describe`, `_files`, `_wanted`, `_values`).
- **bash**: define a function returning `COMPREPLY` and register it with `complete -F <func> <command> [aliases...]`, using `compgen -W` / `compgen -f` / `compgen -d`.

Both branches share the same data (subcommand lists, package lookups, etc.) by inlining the lookup where needed. `compinit` is called by `.zshrc` before `loader.sh`, so `compdef` is always available. In bash, `complete`/`compgen` are builtins and need no setup.

Commands that take no arguments (e.g. `groot`, `synctmux`, `ipmi_status`) intentionally ship no `completion.sh`.