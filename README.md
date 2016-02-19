# 说明

各式各样的配置文件，都是个人使用的，不过为了今后方便自己多系统使用和今后的迁移，写了一些一键安装配置和依赖的脚本。如果你要使用这些配置，对在你的机器上引发的一切不良后果例如蓝屏和发射核导弹概不负责～

# 安装

其中根目录下的`install.sh` 用于整体的安装，每个子目录下的`check_dependence.sh` 用于检查所必须的运行环境是否满足，`install.sh` 用于单独安装配置文件并备份旧的配置文件，`install_dependence.sh` 用于安装配置依赖的运行环境。

如果看了这些你仍然不知道该怎么做，请执行下面的指令同时安装配置文件和所依赖的运行环境：

```bash
git clone https://github.com/Arondight/profile.git ~/profile
cd ~/profile
./install.sh -c -i -d
```

请确保看完**所有**小节之后再进行操作。

# 指令

当你使用zsh 和bash 时，你将可以使用一些额外的指令：

| 指令 | 作用 |
| --- | --- |
| profile-upgrade | 更新这些配置 |
| oh-my-zsh-upgrade | 更新oh-my-zsh |
| [android-env][ID_ANDROID_ENV] | 快速切换到android 开发环境 |
| [archpkg][ID_ARCHPKG] | slackpkg 风格的Arch Linux 包管理器 |
| [less][ID_LESS] | 更舒适的less 指令 |
| [mount*/umount][ID_MOUNT_FUNCTION] | 更加安全便捷的mount/umount |
| [ssh-env][ID_SSH_ENV] | ssh 密钥管理器 |
| [groot][ID_GROOT] | 跳到git 仓库顶层目录 |

[ID_ANDROID_ENV]: https://github.com/Arondight/profile/tree/master/zsh/.zsh/android_env
[ID_ARCHPKG]: https://github.com/Arondight/profile/tree/master/zsh/.zsh/archpkg
[ID_LESS]: https://github.com/Arondight/profile/tree/master/zsh/.zsh/less
[ID_MOUNT_FUNCTION]: https://github.com/Arondight/profile/tree/master/zsh/.zsh/mount_function
[ID_SSH_ENV]: https://github.com/Arondight/profile/tree/master/zsh/.zsh/ssh_env
[ID_GROOT]: https://github.com/Arondight/profile/tree/master/zsh/.zsh/groot


# 依赖

1. bash
+ git
+ cmake
+ gcc
+ clang
+ lua
+ ncurses
+ python-config
+ xz

# 注意

1. 配置文件的安装使用了`ln` 创建软链接，所以一定不要删除`git clone` 生成的目录（默认是~/profile）！
2. color_coded 配置过程用到`clang`，不同发行版中`clang` 所在的包不一定相同，例如Arch Linux 下是**clang** 包，Slackware 下是**llvm** 包，Debian 下则是**clang** 包和**clang-X.Y** 包。
3. YCM 在cmake 的过程中用到`python-config`，不同发行版中`python-config` 所在包不一定相同，例如Arch Linux 和Slackware 下是**python** 包，Debian 下则是**python-dev** 包。
4. color_coded 在配置过程中需要用到`lua` 和`lua.h`，Arch Linux 需要安装**lua** 包，Debian 则需要安装**libluaX.Y-N-dev** 和**luaX.Y**包。
5. Vim 在执行`PluginInstall` 时，会在`Valloric/YouCompleteMe` 上停留很久，请耐心等待。

# 备注

## YouCompleteMe (YCM)

### 更新

现如果你手动更新了YCM，需要执行如下指令配置该插件：

```bash
cd ~/.vim/bundle/YouCompleteMe/build
cmake -G "Unix Makefiles" -DPATH_TO_LLVM_ROOT=$(find ~/.vim/bundle/color_coded/build -maxdepth 1 -type d -name 'clang*') . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
make ycm_support_libs
```

### 替代

如果YCM 无法正常工作，将`~/.vimrc` 中的插件列表做如下改动：

```vim
"Plugin 'Valloric/YouCompleteMe'
Plugin 'Rip-Rip/clang_complete'
```

退出vim，执行指令：

```bash
vim -c 'PluginInstall'
cd ~/.vim/bundle/clang_complete
make && make install
```

之后可以使用Clang Complete 插件替代YCM 进行代码补全。

## color_coded

### 更新

现如果你手动更新了color_coded，需要执行如下指令配置该插件：

```bash
vim -c 'PluginInstall' -c qa
cd ~/.vim/bundle/color_coded
mkdir build
cd build
cmake ..
make install
```

### 替代

如果color_coded 无法正常工作，将`~/.vimrc` 中的插件列表做如下改动：

```vim
"Plugin 'jeaye/color_coded'
Plugin 'octol/vim-cpp-enhanced-highlight'
```

退出vim，执行指令：

```bash
vim -c PluginInstall -c qa
```

之后可以使用vim-cpp-enhanced-highlight 插件替代color_coded 进行代码高亮。

## gruvbox

如果vim 默认配色方案（gruvbox）[显示不正常][ID_GRUVBOX]，将`~/.vimrc` 中的插件列表做如下
改动：

```vim
"Plugin 'morhetz/gruvbox'
Plugin 'tomasr/molokai'
```

然后在`~/.vimrc` 中更换配色方案：

```vim
"colorscheme gruvbox
colorscheme molokai
```

退出vim，执行指令：

```bash
vim -c PluginInstall -c qa
```

之后可以使用molokai 配色替代gruvbox。

[ID_GRUVBOX]: https://github.com/morhetz/gruvbox/wiki/Terminal-specific "跳到gruvbox 的wiki"

