## sysctl

### Configuration files

- `10-network-security.conf` — Network security hardening: disables ICMP broadcast/redirects/source routing, enables SYN-flood protection, reverse path filtering, and more.
- `60-ipv4_bbr.conf` — Enables BBR congestion control and fq qdisc for improved TCP throughput.

> `60-ipv4_bbr.conf` requires kernel BBR support (Linux >= 4.9). Run `sysctl net.ipv4.tcp_available_congestion_control` to check available algorithms; only use this file if the output contains `bbr`.

### Usage

Copy the desired configuration files to `/etc/sysctl.d/`, then run `sudo systemctl restart systemd-sysctl` to apply.
