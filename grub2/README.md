这是用于制作USB 多启动盘的一份GRUB2 配置文件，用于制作一个可以选择从多个ISO 镜像启动的USB 设备。

在为USB 设备安装好GRUB2 后，在GRUB2 配置文件中增加对`custom.cfg` 的引用：

```grub2
### BEGIN /etc/grub.d/41_custom ###
if [ -f  ${config_directory}/custom.cfg ]; then
  source ${config_directory}/custom.cfg
elif [ -z "${config_directory}" -a -f  $prefix/custom.cfg ]; then
  source $prefix/custom.cfg;
fi
### END /etc/grub.d/41_custom ###
```

USB 设备上的分区如下：

```
$ lsblk -o NAME,UUID /dev/sdb
NAME   UUID
sdb
├─sdb1 0bcee804-909d-4f95-a48e-e8aafa1e9dce
└─sdb2 27b788f8-8556-4478-885e-40d4b6aa7383
```

每个分区的大致内容如下：

```
$ tree -L 3 27b788f8-8556-4478-885e-40d4b6aa7383
27b788f8-8556-4478-885e-40d4b6aa7383
└── boot
    ├── grub
    │   ├── custom.cfg
    │   ├── fonts
    │   ├── grub.cfg
    │   ├── grubenv
    │   ├── i386-pc
    │   ├── locale
    │   └── themes
    └── memtest86+
        └── memtest.bin

7 directories, 4 files
```

```
$ tree 0bcee804-909d-4f95-a48e-e8aafa1e9dce
0bcee804-909d-4f95-a48e-e8aafa1e9dce
└── sysimg
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
