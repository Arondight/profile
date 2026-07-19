## mountcmds

Mount and unmount commands with basic safety checks. Each mount command validates that the first argument is a valid block device (matching `/dev/.+\d+`) and the second argument is an existing directory; `mountiso` additionally accepts regular files and `mountdir` accepts two directories for bind mounts.

| Command | Description |
| ------- | ----------- |
| `mountfs` | Mount a block device with `rw,nosuid,nodev,relatime,data=ordered` options |
| `mountntfs` | Mount NTFS partitions with `ntfs-3g` (falls back to `mountfs` if unavailable) |
| `mountfat` | Mount FAT partitions with `iocharset=utf8,umask=000` |
| `mountiso` | Mount ISO images (or block devices) using the `loop` option |
| `mountdir` | Bind-mount a directory to another location |
| `umount` | Unmount one or more devices or mount points via `sudo umount` |