# profile

## About

My Linux config files, tested on Arch Linux, CentOS Stream 10, and Debian 13.

## Dependencies

- coreutils
- gawk
- git
- grep
- make
- clang (also requires clangd on Debian)
- sudo
- tar
- gzip
- vim (vim-nox on Debian)
- xz

> For vim C/C++ completion, the `clangd` LSP server is required. On Arch Linux and CentOS, it is included in the `clang` package. On Debian, install it separately (e.g. `clangd-19`).

## Usage

```bash
mkdir -pv ~/.config/
git clone https://github.com/Arondight/profile.git ~/.config/.profile/
cd ~/.config/.profile/
./install.sh -a
```

> Do not remove `~/.config/.profile/` after install — symlinks point into it.

### Commands

| Command            | Description                            |
| ------------------ | -------------------------------------- |
| `profileupdate`    | Pull latest config from upstream       |
| `profileupdate -f` | Force update, discarding local changes |
| `profilereconf`    | Re-run full install + init pipeline    |

## Plugins

| Plugin                                | Description                                                                        |
| ------------------------------------- | ---------------------------------------------------------------------------------- |
| [alias](zsh/.zsh/alias)               | Shell aliases                                                                      |
| [archpkg](zsh/.zsh/archpkg)           | An Arch Linux package manager in the style of slackpkg                             |
| [custom](zsh/.zsh/custom)             | Load custom user config from `~/.custom_shellrc`                                   |
| [groot](zsh/.zsh/groot)               | Go to the top level of a git repository                                            |
| [ipmi](zsh/.zsh/ipmi)                 | Wrapper for `ipmitool`                                                             |
| [logintmux](zsh/.zsh/logintmux)       | Auto-start tmux on login                                                           |
| [mountcmds](zsh/.zsh/mountcmds)       | Mount/umount commands                                                              |
| [path](zsh/.zsh/path)                 | PATH environment configuration                                                     |
| [profileutils](zsh/.zsh/profileutils) | Update and re-configure all config files using `profileupdate` and `profilereconf` |
| [ssh](zsh/.zsh/ssh)                   | SSH client configuration                                                           |
| [sshenv](zsh/.zsh/sshenv)             | Manage ssh environments                                                            |
| [vimless](zsh/.zsh/vimless)           | A `less` command using `vim`                                                       |
| [vimman](zsh/.zsh/vimman)             | A `man` command using `vim`                                                        |
| oh-my-zsh-upgrade                     | Update oh-my-zsh (a zsh plugin)                                                    |

> Plugins are loaded via [loader.sh](zsh/.zsh/loader.sh) — source it in `~/.zshrc` or `~/.bashrc`.
> All plugins use bash syntax and are compatible with both zsh and bash.

## LICENSE

[MIT-LICENSE](MIT-LICENSE)
