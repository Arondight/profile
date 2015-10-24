这是一个Android 设备的udev 规则列表。

```shell
sudo cp ./51-android.rules /etc/udev/rules.d
sudo chmod 644 /etc/udev/rules.d/51-android.rules
```

对应地，你需要将你需要使用`adb` 操作的设备的**Vendor ID** 写入`~/.android/adb_usb.ini`，**每行一个**。

