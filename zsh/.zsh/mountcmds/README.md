## mountcmds

Mount and unmount commands with basic safety checks. All mount commands create the mount point automatically if it doesn't exist.

| Command | Description |
| ------- | ----------- |
| `mountfs` | Mount a block device by UUID or path. Falls back to udisksctl if available |
| `mountntfs` | Mount NTFS partitions with read-write support |
| `mountfat` | Mount FAT partitions |
| `mountiso` | Mount ISO images using loopback |
| `mountdir` | Bind-mount a directory to another location |
| `umount` | Unmount with `umount` fallback to `udisksctl` |