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

> 请确保看完**所有**小节之后再进行操作。

# 注意

## 本地文件

配置文件的安装使用了`ln` 创建软链接，所以一定不要删除`git clone` 生成的目录（默认是`~/profile`）！

## Vim 界面无反应

Vim 在执行`PluginInstall` 时，会在`Valloric/YouCompleteMe` 上停留很久，请耐心等待。

# 插件

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

# 依赖

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

为什么安装一些配置需要依赖到`vim` 和`clang` 这样的指令，或者是`lua.h` 和`zlib.h` 的提供包？嘛……原因很复杂，总之就是这么设定的！

# Vim

## 插件改动

在**任何**插件改动后都要执行指令：

```bash
profile-reconf
```

## 插件替代

## YouCompleteMe -> clang\_complete

YouCompleteMe 功能强大但是配置相对复杂。可以使用clang\_complete 插件替代YouCompleteMe 进行代码补全：

```vim
"Plugin 'Valloric/YouCompleteMe'
Plugin 'Rip-Rip/clang_complete'
```

## color\_coded -> vim-cpp-enhanced-highlight

color\_coded 是一个基于libclang 的语义级代码高亮插件，精准但是资源消耗大。可以使用vim-cpp-enhanced-highlight 插件替代color\_coded 进行代码高亮：

```vim
"Plugin 'jeaye/color_coded'
Plugin 'octol/vim-cpp-enhanced-highlight'
```

## gruvbox -> molokai

grubbox 是一个保护视力的配色方案，但色彩较单一。可以使用molokai 配色替代gruvbox：

```vim
"Plugin 'morhetz/gruvbox'
Plugin 'tomasr/molokai'
```

```vim
"colorscheme gruvbox
colorscheme molokai
```

