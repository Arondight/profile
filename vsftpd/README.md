一个只允许匿名登录、不提供写权限的vsftpd 配置文件。

```shell
sudo mkdir -p /home/ftp/root
sudo chmod 0755 -R /home/ftp/root
sudo chown $USER:$USER -R /home/ftp/root
sudo gpasswd -a $USER ftp
sudo usermod -d /home/ftp/root ftp
sudo mkdir -p /var/empty
```

