这是一个 bash 和其他 shell 的接口配置，用于其他 shell 向 bash 转换时指定 bash 初始行为。

你需要将期望 bash 完成的操作以 `.sh`文件的形式写入 `~/.bash/interface/` ，然后像下面这样调用 bash：

```sh
bash --init-file ~/.bash/interface.sh
```

这个功能只是实验性的，请不要使用。
