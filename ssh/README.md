我的SSH 密钥对，仅作存放和备份，（当然）不会被安装。

```bash
gpg ssh-env.tar.gz.asc
sshenv import ssh-env
rm -f ssh-env.tar.gz
```

