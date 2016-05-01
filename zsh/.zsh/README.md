这是一个shell 的插件目录，使用了bash 语法，可以由所有兼容bash 语法的shell 加载。

- [x] Zsh
- [x] bash
- [x] dash

在你的shell 配置文件中加入以下语句：

```bash
source $HOME/.zsh/reactor.sh
```

其中的插件必须：

1. 在`$HOME/.zsh/reactor.sh` 的`myPluginLoader` 函数中注册
+ 逻辑必须适合在当前shell 执行，而非作为脚本执行
+ 权限可读且不可执行
+ 因为zsh 和bash/dash 数组下标规则不同，想要写通用的插件就不能够使用任何数组下标

