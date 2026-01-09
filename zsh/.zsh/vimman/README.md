在 Vim 中查看 Manual。

在你的 `~/.vimrc` 中加入下面两行：

```viml
runtime ftplugin/man.vim    ; 加载插件
nmap ,m :Man <cword><CR>    ; 快捷手册
```

可以在关键词之前指定 section，可以跟多个 section 和关键词作为参数，例如

```sh
vman man
vman 2 socket
vman 2 printf 1 read write 5 passwd
```
