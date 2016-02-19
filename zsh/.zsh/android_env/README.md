如果你的系统是Arch Linux，你还需要设置一些软连接：

运行本目录下的初始化脚本：

```bash
./init.sh
```

或者手动执行（你需要清楚你在做什么）：

```bash
echo /usr/lib/{libtinfo.so{,.5,.6},libncurses.so{.5,.6}} |\
  xargs -d ' ' -I {} sudo ln -s /usr/lib/libncursesw.so {}
```

| 需要的库 | 定向到 |
| --- | --- |
| /usr/lib/libtinfo.so | /usr/lib/libncursesw.so |
| /usr/lib/libtinfo.so.5 | /usr/lib/libncursesw.so |
| /usr/lib/libtinfo.so.6 | /usr/lib/libncursesw.so |
| /usr/lib/libncurses.so.5 | /usr/lib/libncursesw.so |
| /usr/lib/libncurses.so.6 | /usr/lib/libncursesw.so |

