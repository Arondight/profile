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