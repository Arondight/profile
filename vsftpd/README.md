密码验证、不支持匿名访问的 ftp 服务器。

```sh
sudo mkdir -p /home/ftp/root
sudo chmod 0755 -R /home/ftp/root
sudo useradd -g ftp -d /home/ftp/root ftp
sudo passwd ftp
sudo chown ftp:ftp -R /home/ftp/root
sudo gpasswd -a $USER ftp
sudo mkdir -p /var/empty
```
