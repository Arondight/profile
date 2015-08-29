# 说明
各式各样的配置文件，都是个人使用的，不过为了今后方便自己多系统使用和今后的迁移，写了一些一键安装配置和依赖的脚本。如果你要使用这些配置，对在你的机器上引发的一切不良后果例如蓝屏和发射核导弹概不负责～

# 安装
其中根目录下的`install.sh` 用于整体的安装，每个子目录下的`check_dependence.sh` 用于检查所必须的运行环境是否满足，`install.sh` 用于单独安装配置文件并备份旧的配置文件，`install_dependence.sh` 用于安装配置依赖的运行环境。

如果看了这些你仍然不知道该怎么做，请执行下面的指令同时安装配置文件和所依赖的运行环境：

```shell
git clone https://github.com/Arondight/profile.git ~/profile
cd ~/profile
./install.sh -c -i -d
```

请确保看完**注意**小节之后再进行操作。

# 升级
你可以使用下面的指令使这些配置文件保持最新（当你使用zsh 的时候）：

```shell
profile_upgrade
```

# 注意
1. 配置文件的安装使用了`ln` 创建软链接，所以一定不要删除`git clone` 生成的目录（默认是~/profile）！

2. 虽然YCM 的作者反对使用系统clang，但是综合各种状况，更推荐在系统中预先安装llvm/clang 以提供YCM 使用的libclang.so。不同发行版中libclang.so 所在的包名不一定相同，例如Archlinux 下是*clang* 包，Slackware 下是*llvm* 包，Debian 下则是*libclang-dev* 包。

3. YCM 在cmake 的过程中用到`python-config`，不同发行版中`python-config` 所在包不一定相同，例如Archlinux 和Slackware 下是*python* 包，Debian 下则是*python-dev* 包。

4. Vim 在执行`PluginInstall` 时，会在`Valloric/YouCompleteMe` 上停留很久，请耐心等待。

# 备注
如果你因为未使用系统libclang.so 而导致YCM 配置失败，在使用包管理器准备好libclang.so 之后运行以下命令重新配置YCM。

```shell
cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer --system-libclang
```

当然，如果你手动更新了YCM，你也需要再次执行上面的指令。

如果YCM 依然无法正常工作，将`~/.vimrc` 中的插件列表做如下改动：

```vim
"Plugin 'Valloric/YouCompleteMe'
Plugin 'Rip-Rip/clang_complete'
```

之后退出vim，执行指令：

```shell
vim -c 'PluginInstall'
cd ~/.vim/bundle/clang_complete
make install
```

之后可以使用Clang Complete 插件替代YCM 进行代码补全。

