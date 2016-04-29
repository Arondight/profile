# 说明

各式各样的配置文件，都是个人使用的，不过为了今后方便自己多系统使用和今后的迁移，写了一些一键安装配置和依赖的脚本。如果你要使用这些配置，对在你的机器上引发的一切不良后果例如蓝屏和发射核导弹概不负责。

支持的架构为x86 系列（x86/x86\_64/amd64）。

测试通过的系统：

- [x] Arch Linux
- [ ] Debian 8
- [ ] Ubuntu 16.04
- [ ] CentOS 7
- [ ] openSUSE 13.2
- [ ] Slackware 14.2

> 通常来说，只要系统不要太老即可，上面没过的基本都是没测。

# 安装

其中根目录下的`install.sh` 用于整体的安装，每个子目录下的`check.sh` 用于检查系统环境，`install.sh` 用于备份并复制配置文件，`init.sh` 用于搭建配置需要的运行环境，`install.force.sh` 用于手动安装一些可能需要保持机器上独立的配置。

如果看了这些你仍然不知道该怎么做，执行：

```bash
git clone https://github.com/Arondight/profile.git ~/profile
cd ~/profile
./install.sh -a
```

请确保看完**所有**小节之后再进行操作。

# 指令

当你使用`zsh` 和`bash` 作为登陆Shell 时，你将可以使用一些额外的指令：

| 指令 | 作用 |
| --- | --- |
| profile-upgrade | 更新这些配置源文件 |
| profile-reconf | 重新设置这些配置文件 |
| oh-my-zsh-upgrade | 更新oh-my-zsh |
| [android-env][ID_ANDROID_ENV] | 快速切换到android 开发环境 |
| [apply][ID_APPLY] | 补丁操作 |
| [archpkg][ID_ARCHPKG] | slackpkg 风格的Arch Linux 包管理器 |
| [groot][ID_GROOT] | 跳到git 仓库顶层目录 |
| [iam][ID_IAM] | 为git 仓库配置user 信息 |
| [less][ID_LESS] | 更舒适的less 指令 |
| [mount_function][ID_MOUNT_FUNCTION] | 更加安全便捷的mount/umount |
| [ssh-env][ID_SSH_ENV] | ssh 密钥管理器 |
| [vman][ID_VMAN] | 在Vim 中查看Manual |

[ID_ANDROID_ENV]: zsh/.zsh/android_env
[ID_APPLY]: zsh/.zsh/apply
[ID_ARCHPKG]: zsh/.zsh/archpkg
[ID_IAM]: zsh/.zsh/iam
[ID_LESS]: zsh/.zsh/less
[ID_MOUNT_FUNCTION]: zsh/.zsh/mount_function
[ID_SSH_ENV]: zsh/.zsh/ssh_env
[ID_GROOT]: zsh/.zsh/groot
[ID_VMAN]: zsh/.zsh/vman

# 依赖

## 依赖列表

| 文件 | 指令 |
| --- | --- |
| `curses.h` | `awk` |
| `lua.h` | `clang` |
| `zlib.h` | `cmake` |
| | `date` |
| | `gcc` |
| | `git` |
| | `grep` |
| | `install` |
| | `ln` |
| | `md5sum` |
| | `mkdir` |
| | `mv` |
| | `python-config` |
| | `readlink` |
| | `rm` |
| | `tail` |
| | `uniq` |
| | `vim` |
| | `xz` |

> 其中`文件`字段表示你需要安装能够提供该文件的包；`指令`字段表示你只要能够提供一个可以正常使用的该指令即可。

为什么安装一些配置需要依赖到`vim` 和`clang` 这样的指令，或者是`lua.h` 或者`zlib.h` 的提供包？嘛……原因很复杂，总之就是这么设定的！

## clang

color\_coded 配置过程用到`clang`，不同发行版中`clang` 所在的包不一定相同，例如Arch Linux 下是`clang` 包，Slackware 下是`llvm` 包，Debian 下则是`clang` 包和`clang-X.Y` 包。

## python-config

YCM 在cmake 的过程中用到`python-config`，不同发行版中`python-config` 所在包不一定相同，例如Arch Linux 和Slackware 下是`python` 包，Debian 下则是`python-dev` 包。

## lua

color\_coded 在配置过程中需要用到`lua` 和其开发包，Arch Linux 需要安装`lua` 包，Debian 则需要安装`libluaX.Y-N-dev` 和`luaX.Y`包。

# 注意

## 本地文件

配置文件的安装使用了`ln` 创建软链接，所以一定不要删除`git clone` 生成的目录（默认是~/profile）！

## Vim 界面无反应

Vim 在执行`PluginInstall` 时，会在`Valloric/YouCompleteMe` 上停留很久，请耐心等待。

# Vim

## 插件改动

在**任何**插件改动后都要执行指令：

```bash
profile-reconf
```

## 插件替代

## YouCompleteMe (YCM)

可以使用Clang Complete 插件替代YCM 进行代码补全：

```vim
"Plugin 'Valloric/YouCompleteMe'
Plugin 'Rip-Rip/clang_complete'
```
## color\_coded

可以使用vim-cpp-enhanced-highlight 插件替代color\_coded 进行代码高亮：

```vim
"Plugin 'jeaye/color_coded'
Plugin 'octol/vim-cpp-enhanced-highlight'
```

## gruvbox

可以使用molokai 配色替代gruvbox：

```vim
"Plugin 'morhetz/gruvbox'
Plugin 'tomasr/molokai'
```

```vim
"colorscheme gruvbox
colorscheme molokai
```

