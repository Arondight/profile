#乱七八糟的说明
一些乱七八糟的配置文件，都是个人使用的，不过为了今后方便自己多系统使用和今后的迁移，写了一些一键安装配置和依赖的脚本。

如果你要使用这些配置，对在你的机器上引发的一切不良后果例如蓝屏和发射核导弹概不负责～

#正确的安装姿势
执行指令

`git clone https://github.com/iSpeller/Profile.git ~/Profile`

`cd ~/Profile`

其中的`install.sh` 用于备份旧的配置文件并安装新的配置文件，`install_dependence.sh` 用于安装配置依赖的运行环境，每个子目录下的`install.sh` 用于单独安装配置文件（但是不关心依赖）。

*另外虽然YCM 的作者反对使用系统clang，但是使用YCM 自带的install.sh 脚本下载、链接并生成的libclang.so 似乎会导致YCMServer 崩溃，使用系统clang 链接生成libclang.so 似乎可以避免这个问题，如果不相信人品在系统中预先安装clang 编译器。另外已知Vim 中打开TagList 会造成Syntastic 失效，使用完毕后关掉TagList 即可恢复正常。*

如果看了这么多你仍然不知道该怎么做，请执行下面的指令同时安装配置文件和所依赖的运行环境

`sh ./install.sh --with-dependence`

然后为即将到来的libclang.so 祈祷吧！

#非常坑爹的备注
### 关于配置文件的创建
`install.sh` 中，配置文件的创建使用了ln 创建软链接，所以一定不要删除安装第一步git clone 生成的目录（默认是~/Profile）！

### 关于依赖的进一步说明
注意：脚本并不会安装那些必须依赖的软件：例如会安装oh-my-zsh 但不会安装zsh；例如会安装vim 的插件但不会安装gvim。

