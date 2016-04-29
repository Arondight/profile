这是一个shell 的通用配置目录，使用了bash 语法，可以由所有兼容bash 语法的shell 加载。

在你的shell 配置文件中加入以下语句：

```bash
source $HOME/.zsh/reactor.sh
```

> 目前已知兼容bash、dash 和zsh，虽然数组下标规则不统一，但是这些脚本中未使用任何数组下标。

