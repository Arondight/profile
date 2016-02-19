在Vim 中查看Manual。

在你的`~/.vimrc` 中加入下面两行：

```vimrc
runtime ftplugin/man.vim    # 加载插件
nmap ,m :Man <cword><CR>    # 快捷手册
```

可以在关键词之前指定section，可以跟多个section 和关键词作为参数，例如

```bash
vman man
vman 2 socket
vman 2 printf 1 read write 5 /etc/passwd
```

