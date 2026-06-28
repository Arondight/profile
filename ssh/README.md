## ssh

Personal SSH key backup, encrypted with GPG and stored as base64. Import and export use the [sshenv](../zsh/.zsh/sshenv) plugin.

> RSA keys are no longer supported by default on modern systems. If you use RSA keys, add `PubkeyAcceptedKeyTypes +ssh-rsa` to `sshd_config`.

### Import

```bash
sshenv import <(gpg --default-key $(cat ./fingerprint) -o- -d <(base64 -d ./ssh-env.tar.gz.asc.base64))
```

### Export

```bash
sshenv export ssh-env
base64 >./ssh-env.tar.gz.asc.base64 < <(gpg -r $(cat ./fingerprint) -o- -ae ./ssh-env.tar.gz)
rm -f ./ssh-env.tar.gz
```
