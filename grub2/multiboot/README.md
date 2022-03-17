这是用于制作 USB 多启动盘的一系列 GRUB2 配置文件，用于制作一个可以选择从多个 ISO 镜像启动的 USB 设备。

其中， `grub.cfg` 已将主题指定为[Dacha204/grub2-themes-Ettery](https://github.com/Dacha204/grub2-themes-Ettery)。

---

USB 设备上的分区如下：

```
$ lsblk -o NAME,LABEL,FSTYPE,UUID /dev/sdb
NAME   LABEL FSTYPE UUID
sdb
├─sdb1 data  ntfs   5AC560670CEADC8F
├─sdb2 image ext4   97e75763-3409-46df-b88d-ba5f234bf6f8
└─sdb3 boot  ext4   30a8bfb5-933c-4a52-8b7f-953ab7c58a0e
```

`sdb3` 的大致内容如下：

```
$ tree -L 3 boot
boot
└── boot
    ├── grub
    │   ├── custom.cfg
    │   ├── device.cfg
    │   ├── fonts
    │   ├── grub.cfg
    │   ├── grubenv
    │   ├── i386-pc
    │   ├── locale
    │   └── themes
    └── memtest86+
        └── memtest.bin

7 directories, 5 files
```

`sdb2` 的大致内容如下：

```
$ tree -a image
image
└── .image
    ├── ArchLinux
    │   └── archlinux-2016.04.01-dual.iso
    ├── CentOS
    │   └── CentOS-7-x86_64-LiveGNOME-1511.iso
    ├── Debian
    │   └── debian-live-8.4.0-amd64-gnome-desktop.iso
    ├── Fedora
    │   └── Fedora-Live-Workstation-x86_64-23-10.iso
    ├── Gentoo
    │   └── install-amd64-minimal-20160414.iso
    ├── openSUSE
    │   └── openSUSE-13.2-KDE-Live-x86_64.iso
    └── Ubuntu
        └── ubuntu-16.04-desktop-amd64.iso

8 directories, 7 files
```
