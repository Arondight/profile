## logintmux

Auto-start tmux on login, useful for SSH environments that don't support window splitting.

| Function | Description |
| -------- | ----------- |
| `synctmux` | Start tmux in synchronized mode — all terminals share the same tmux session |
| `nosynctmux` | Start tmux in independent mode — each terminal gets its own session |
| `loginTmux` | Use tmux as the login shell |

> BUG: `scp` to the target machine may not work when tmux is used as the login shell.