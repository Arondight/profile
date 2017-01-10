这是一个`apache` 的文件浏览样式，使用方法请查看[apache.patch](apache.patch)。这份Patch 是在Arch Linux 的`/etc` 目录下生成的，其他发行版需要对应修改。

另外需要将`.web` 目录复制到`DocumentRoot`，例如。

```bash
cp -rvf .web /home/ftp/root
```

> 1. 如果是Red Hat 系列发行版，需要留意文件`/etc/httpd/conf.d/welcome.conf`。
> 2. `httpd.conf`和`extra/httpd-autoindex.conf`为Arch Linux 下apache 配置文件的备份，**不具备**发行版之间的通用性。

