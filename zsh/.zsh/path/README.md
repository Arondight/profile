## path

Custom PATH configuration. Any readable, non-executable `.sh` file in this directory is sourced automatically by `myPathLoader` in `loader.sh`. After all files are sourced, `.` is appended to `PATH` as the very last entry.

### Included paths

| File | Adds to PATH |
|------|-------------|
| `bin_path.sh` | `/bin`, `/sbin`, `/usr/bin`, `/usr/sbin`, `/usr/local/bin`, `/usr/local/sbin`, `~/bin` |
| `local_bin_path.sh` | `~/bin` |
| `cpan_path.sh` | (commented out) Perl CPAN user module paths |
| `go_path.sh` | Sets `GOPATH=~/.lib/go` and adds `$GOPATH/bin` to PATH |