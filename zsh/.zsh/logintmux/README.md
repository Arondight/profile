## logintmux

Auto-start tmux on login, useful for SSH environments that don't support window splitting.

| Function | Description |
| -------- | ----------- |
| `synctmux` | Start tmux in synchronized mode — all terminals share the same tmux session |
| `unsynctmux` | Start tmux in independent mode — each terminal gets its own session |
| `loginTmux` | Prompt to use tmux as the login shell on SSH login |

> BUG: `scp` to the target machine may not work when tmux is used as the login shell.