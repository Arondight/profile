## sshenv

An SSH key manager for managing multiple sets of keys. Existing keys are preserved without modification on first launch.

### Commands

| Command | Description |
|---------|-------------|
| `sshenv list` | List all available environments |
| `sshenv use [environment]` | Switch to an environment as the default SSH key |
| `sshenv new [environment] <email>` | Create a new environment with the given email |
| `sshenv delete [environment]` | Export and delete an environment |
| `sshenv rename [old] [new]` | Rename an environment |
| `sshenv export [tarball]` | Export all environments to a tarball |
| `sshenv import [tarball]` | Import environments from a tarball |
| `sshenv help` | Show help message |

Aliases `ssh-env` and `ssh_env` are also available. The working directory defaults to `~/.ssh_env` and can be overridden via the `SSHENV_WORK_DIR` environment variable.