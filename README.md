# profile

## 说明

各式各样的配置文件，都是个人使用的，不过为了今后方便自己多系统使用和今后的迁移，写了一些一键安装配置和依赖的脚本。如果你要使用这些配置，对在你的机器上引发的一切不良后果例如蓝屏和发射核导弹概不负责。

支持的架构为`X86`。

测试通过的系统：

- [x] Arch Linux
- [x] CentOS 7.3
- [x] Debian 8.5.0
- [x] Fedora 26
- [x] openSUSE 42.2
- [x] Slackware 14.2
- [x] Ubuntu 16.04

## 安装

其中根目录下的`install.sh` 用于整体的安装，每个子目录下的`check.sh` 用于检查系统环境，`install.sh` 用于备份并复制配置文件，`init.sh` 用于搭建配置需要的运行环境，`install.force.sh` 用于手动安装一些可能需要保持机器上独立的配置。

如果看了这些你仍然不知道该怎么做，执行：

```bash
git clone https://github.com/Arondight/profile.git ~/profile
cd ~/profile
./install.sh -a
```

> 配置文件的安装使用了`ln` 创建软链接，所以一定不要删除`git clone` 生成的目录（默认是`~/profile`）！

## 插件

当你使用`zsh` 和`bash` 作为登陆Shell 时，你将可以使用一些小插件：

| 指令 | 作用 |
| --- | --- |
| [profileupdate](zsh/.zsh/profileutils) | 更新配置仓库 |
| [profilereconf](zsh/.zsh/profileutils) | 重设运行环境 |
| oh-my-zsh-upgrade | 更新oh-my-zsh |
| [androidenv](zsh/.zsh/androidenv) | 切换到安卓开发环境 |
| [apply](zsh/.zsh/apply) | 补丁操作 |
| [archpkg](zsh/.zsh/archpkg) | slackpkg 风格的Arch Linux 包管理器 |
| [groot](zsh/.zsh/groot) | 跳到git 仓库顶层目录 |
| [less](zsh/.zsh/less) | 更舒适的less |
| [mountcmds](zsh/.zsh/mountcmds) | 一系列挂载、卸载指令 |
| [sshenv](zsh/.zsh/sshenv) | ssh 密钥管理器 |
| [vman](zsh/.zsh/vman) | 更舒适的Manual |

## 依赖

系统中需要提供以下指令。

`awk`, `clang`, `date`, `git`, `grep`, `install`, `ln`, `md5sum`, `make`, `mkdir`, `mv`, `readlink`, `rm`, `tail`, `uniq`, `vim`, `xz`

## Vim

在**任何**插件改动后都要执行指令。

```bash
profilereconf
```

## 版权

[MIT-LICENSE](MIT-LICENSE)

Copyright (c) 2015-2017 秦凡东(Qin Fandong)

