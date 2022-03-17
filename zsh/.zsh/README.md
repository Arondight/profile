这是一个 shell 的插件目录，使用了 bash 语法，可以由所有兼容 bash 语法的 shell 加载。在你的 shell 配置文件中加入以下语句：

```sh
source $HOME/.zsh/reactor.sh
```

其中的插件必须：

1. 在 `~/.zsh/reactor.sh` 的 `myPluginLoader` 函数中注册
2. 逻辑必须适合在当前 shell 执行，而非作为脚本执行
3. 权限可读且不可执行
4. 因为 zsh 和 bash/dash 数组下标规则不同，想要写通用的插件就不能够使用任何数组下标
