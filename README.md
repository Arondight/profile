# profile

## About

My Linux config files, tested on Arch Linux, CentOS Stream 10, Debian 13, and Kylin V11.

## Dependencies

### Arch Linux

```shell
sudo pacman -S c{oreutils,lang} g{awk,it,rep,zip} make sudo tar vim xz
```

### CentOS Stream 10

```shell
sudo dnf install c{oreutils,lang{,-tools-extra}} g{awk,it,rep,zip} make sudo tar vim xz
```

### Debian 13 and Kylin V11

```shell
sudo apt install c{oreutils,lang{,d}} g{awk,it,rep,zip} make sudo tar vim-nox xz-utils
```

> The `clangd` LSP server is required for vim C/C++ completion.

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
| [ssh](zsh/.zsh/ssh)                   | `ssh_forget` helper to prune `~/.ssh/known_hosts`                                  |
| [sshenv](zsh/.zsh/sshenv)             | Manage ssh environments                                                            |
| [vimless](zsh/.zsh/vimless)           | A `less` command using `vim`                                                       |
| [vimman](zsh/.zsh/vimman)             | A `man` command using `vim`                                                        |
| oh-my-zsh-upgrade                     | Update oh-my-zsh (a zsh plugin)                                                    |

> All plugins use bash syntax and are compatible with both zsh and bash.
> Each plugin may ship a `completion.sh` next to its main script to provide zsh/bash tab completion.

## LICENSE

[MIT-LICENSE](MIT-LICENSE)
