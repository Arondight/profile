与 vsftpd 配置配合使用， Arch Linux 配置文件，仅供参考。如果是 Red Hat 系列发行版，需要留意文件 `/etc/httpd/conf.d/welcome.conf` 。

```sh
cp -rvf .web /home/ftp/root/
sudo htpasswd -c /home/ftp/root/.web/passwords http
```
