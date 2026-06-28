## path

Custom PATH configuration. Any readable, non-executable `.sh` file in this directory is sourced automatically.

### Included paths

| File | Adds to PATH |
|------|-------------|
| `bin_path.sh` | `~/.local/bin`, `~/.bin` |
| `local_bin_path.sh` | `/usr/local/bin`, `/usr/local/sbin` |
| `cpan_path.sh` | Perl CPAN module paths |
| `go_path.sh` | `$GOPATH/bin`, `$GOROOT/bin` |