Life is short, I use Zsh.

#### 指令补全

```bash
$ sys-an<TAB>             # -> systemd-analyze
```

#### 指令纠错

```bash
$ gerp<TAB>               # -> gerp
```

#### 指令错误提示

```bash
$ nuame                   # 红色
$ uname                   # 绿色
```

#### 文件存在性提示

```bash
$ echo >file.txt          # file.txt 存在则加下划线，否则不加
```

#### 参数补全

```bash
$ unzip example.zip<TAB>  # 当前除了example.zip 外所有可被操作的zip 归档文件
$ git checkout <TAB>      # 项目中所有可被checkout 的分支或提交
$ systemctl status <TAB>  # 系统中所有的服务
$ kill x<TAB>             # 所有名字以x 开头并有权限杀死的进程
$ ls -<TAB>               # ls 指令所有的选项及其含义
$ file ~/T*<TAB>          # 主目录下所有以T 为开头文件的列表
$ echo $t                 # 所有以t/T 开头的环境变量
# 以及更多智能化的补全
```

#### 参数纠错

```bash
$ gcc -unuse-f<TAB>       # -> gcc -Wunused-function
$ git sibmode<TAB>        # -> git submodule
```

#### 更强大的重定向

```bash
$ git pull |& >>log       # 追加stdout/stderr 到file
$ date >log{1,2} >file    # 重定向stdout 到log1 log2 file 三个文件
```

#### 路径补全

```bash
$ less /u/i/am/errno<TAB> # -> less /usr/include/asm/errno.h
```

#### 路径历史

```bash
$ cd -<TAB>               # 近期访问的路径
```

#### 科学计算器

```bash
$ 4*atan(1.0)<Ctrl+E><Enter>  # -> 3.1415926535897931
```

#### 快速临时文件

```bash
$ diff =(ls A) =(ls B)    # 将ls A 和ls B 的输出保存为临时文件并用diff 比较
$ vim =(ps -aux)          # 将ps -aux 的输出保存为临时文件并用vim 编辑
```

#### sudo

```bash
$ systemctl restart NetworkManager<ESC><ESC>  # -> sudo systemctl restart NetworkManager
```

**使用原则**：遇到问题，无脑TAB。

