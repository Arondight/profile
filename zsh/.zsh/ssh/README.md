## ssh

Small SSH-related helpers sourced by `loader.sh`.

### Commands

| Command | Description |
| ------- | ----------- |
| `ssh_forget` / `ssh-forget` | Delete a single line from `~/.ssh/known_hosts` by 1-based line number |

### Usage

```sh
ssh_forget 3      # remove the 3rd entry from ~/.ssh/known_hosts
ssh-forget 3      # alias
```

The line number must be a positive integer. The function refuses to operate if `~/.ssh/known_hosts` is missing or not writable.
