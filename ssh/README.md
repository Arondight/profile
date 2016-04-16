我的SSH 密钥对，仅作存放和备份，（当然）不会被安装。

```
$ gpg ssh-env.tar.gz.asc
$ ssh-env import ssh-env
$ rm -f ssh-env.tar.gz
```

