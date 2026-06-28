## zsh

Zsh configuration with oh-my-zsh, syntax highlighting, autosuggestions, and completions.

### Features

### Command completion

```sh
$ sys-an<TAB>             # -> systemd-analyze
```

### Command correction

```sh
$ gerp<TAB>               # -> gerp
```

### Error highlighting

```sh
$ nuame                   # red
$ uname                   # green
```

### File existence hint

```sh
$ echo >file.txt          # file.txt is underlined if it exists
```

### Argument completion

```sh
$ unzip example.zip<TAB>  # all zip archives except example.zip
$ git checkout <TAB>      # all check-outable branches and commits
$ systemctl status <TAB>  # all system services
$ kill x<TAB>             # all processes starting with x that you can kill
$ ls -<TAB>               # all ls options with descriptions
$ file ~/T*<TAB>          # all files in home starting with T
$ echo $t                 # all environment variables starting with t/T
```

### Argument correction

```sh
$ gcc -unuse-f<TAB>       # -> gcc -Wunused-function
$ git sibmode<TAB>        # -> git submodule
```

### Advanced redirection

```sh
$ git pull |& >>log       # append stdout/stderr to log
$ date >log{1,2} >file    # redirect stdout to log1, log2, and file
```

### Path completion

```sh
$ less /u/i/am/errno<TAB> # -> less /usr/include/asm/errno.h
```

### Directory history

```sh
$ cd -<TAB>               # recently visited directories
```

### Calculator

```sh
$ 4*atan(1.0)<Alt+Shift+E><Enter>   # -> 3.1415926535897931
```

### Temporary files

```sh
$ diff =(ls A) =(ls B)    # compare output of ls A and ls B
$ vim =(ps -aux)          # edit ps output in vim
```

### sudo

```sh
$ systemctl restart NetworkManager<ESC><ESC>  # -> sudo systemctl restart NetworkManager
```

> Press TAB often.
