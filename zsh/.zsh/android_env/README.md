你还需要设置以下软连接：

```shell
[[ ! -e /usr/lib/libtinfo.so.6 ]] && sudo ln -s /usr/lib/libncursesw.so /usr/lib/libtinfo.so.6
[[ ! -e /usr/lib/libtinfo.so.5 ]] && sudo ln -s /usr/lib/libncursesw.so /usr/lib/libtinfo.so.5
[[ ! -e /usr/lib/libtinfo.so ]] && sudo ln -s /usr/lib/libncursesw.so /usr/lib/libtinfo.so
[[ ! -e /usr/lib/libncurses.so.5 ]] && sudo ln -s /usr/lib/libncursesw.so /usr/lib/libncurses.so.5
[[ ! -e /usr/lib/libncurses.so.6 ]] && sudo ln -s /usr/lib/libncursesw.so /usr/lib/libncurses.so.6
```

