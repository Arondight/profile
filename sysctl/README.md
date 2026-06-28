## sysctl

### 配置文件

- `10-network-security.conf`：网络与安全相关内核参数：禁用 ICMP 广播/重定向/源路由、开启 SYN-flood 保护、反向路径过滤等。
- `60-ipv4_bbr.conf`：启用 BBR 拥塞控制算法和 fq 排队规则，提升 TCP 吞吐量。

> `60-ipv4_bbr.conf` 需要内核支持 BBR。使用 `sysctl net.ipv4.tcp_available_congestion_control` 查看可用算法，输出包含 `bbr` 方可使用。

### 使用

将需要的配置文件复制到 `/etc/sysctl.d/`，然后执行 `sudo systemctl restart systemd-sysctl` 使其生效。
