# profile

## About

My software config files, tested on Arch Linux, CentOS Stream 10, Debian 13.

## Dependencies

- coreutils
- gawk
- git
- grep
- make
- clang
- sudo
- tar
- gzip
- vim (vim-nox on Debian)
- xz

## Usage

```bash
mkdir -pv ~/.config/
git clone https://github.com/Arondight/profile.git ~/.config/.profile/
cd ~/.config/.profile/
./install.sh -a
```

> Do not remove `~/.config/.profile/` after install.

## Plugins

| Plugin                                | Description                                                                        |
| ------------------------------------- | ---------------------------------------------------------------------------------- |
| [alias](zsh/.zsh/alias)               | Shell aliases                                                                      |
| [archpkg](zsh/.zsh/archpkg)           | An Arch Linux package manager in the style of slackpkg                             |
| [custom](zsh/.zsh/custom)             | Load custom user config from `~/.custom_shellrc`                                   |
| [groot](zsh/.zsh/groot)               | Go to top level of a git repository                                                |
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
