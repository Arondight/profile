这是一个bash 和其他shell 的接口配置，用于其他shell 向bash 转换时指定bash 初始行为。

你需要将期望bash 完成的操作以`.sh`文件的形式写入`~/.bash/interface/`，然后像下面这样调用bash：

```bash
bash --init-file ~/.bash/interface.sh
```

这个功能只是实验性的，请不要使用。

