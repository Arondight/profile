# profile

## About

My software config files, tested on Arch Linux, CentOS Stream 10, Debian 13.

## Dependence

- gawk
- clang
- coreutils
- git
- grep
- make
- vim
- xz

## Usage

```bash
mkdir -p ~/.config/
git clone https://github.com/Arondight/profile.git ~/.config/.profile/
cd ~/.config/.profile/
./install.sh -a
```

> Do not remove `~/.config/.profile/` after install.

## Plugins

| Plugin                                | 作用                                                                            |
| ------------------------------------- | ------------------------------------------------------------------------------- |
| [archpkg](zsh/.zsh/archpkg)           | An Arch Linux package manager in the style of slackpkg                          |
| [groot](zsh/.zsh/groot)               | Go to top level of a git repository                                             |
| [ipmi](zsh/.zsh/ipmi)                 | Wrapper for `ipmitool`                                                          |
| [mountcmds](zsh/.zsh/mountcmds)       | Mount/umount commands                                                           |
| [profileutils](zsh/.zsh/profileutils) | Update and re-config all config files using `profileupdate` and `profilereconf` |
| [sshenv](zsh/.zsh/sshenv)             | Manage ssh environments                                                         |
| [vimless](zsh/.zsh/less)              | A `less` command using `vim`                                                    |
| [vimman](zsh/.zsh/vman)               | A `man` command using `vim`                                                     |
| oh-my-zsh-upgrade                     | Update oh-my-zsh (a zsh plugin)                                                 |

> Plugin [custom](zsh/.zsh/custom) will read `~/.custom_shellrc`.

## LICENSE

[MIT-LICENSE](MIT-LICENSE)
