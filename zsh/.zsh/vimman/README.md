## vimman

View man pages in Vim with syntax highlighting and navigation.

### Usage

```sh
vman man
vman 2 socket
vman 2 printf 1 read write 5 passwd
```

Specify a section number (1-9) before the keyword. Multiple section/keyword pairs can be passed in a single command.

### Requirements

Requires `runtime ftplugin/man.vim` in `~/.vimrc` (already included in this profile).