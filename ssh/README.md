个人 SSH 密钥备份。因为 RSA 密钥已经不被支持，可能需要在 `sshd` 配置文件中配置 `PubkeyAcceptedKeyTypes +ssh-rsa` 。

导入。

```bash
sshenv import <(gpg --default-key $(cat ./fingerprint) -o- -d <(base64 -d ./ssh-env.tar.gz.asc.base64))
```

导出。

```bash
sshenv export ssh-env
base64 >./ssh-env.tar.gz.asc.base64 < <(gpg -r $(cat ./fingerprint) -o- -ae ./ssh-env.tar.gz)
rm -f ./ssh-env.tar.gz
```
