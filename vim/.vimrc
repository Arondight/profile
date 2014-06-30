" ==========================
" vim 配置文件
" 位置: ~/.vimrc
" 需要: gvim
"
"           by:iSpeller
" ==========================

" ==========================
" Vundle
" ==========================
" :PluginList           - 列出配置的插件
" :PluginInstall(!)     - 安装/更新插件
" :PluginSearch(!) foo  - 查找插件foo(首先更新缓存)
" :PluginClean(!)       - 清理被注释掉的插件
" :h vundle             - 帮助手册
" =========================
set nocompatible                      " 不兼容Vi
filetype off                          " required
set rtp+=~/.vim/bundle/Vundle.vim     " Vundle 路径
call vundle#begin()                   " call vundle#begin('~/some/path/here')
" 插件列表 {
Plugin 'vim-scripts/a.vim'
Plugin 'vim-scripts/c.vim'
Plugin 'vim-scripts/Align'
Plugin 'vim-scripts/AuthorInfo'
Plugin 'vim-scripts/DrawIt'
Plugin 'vim-scripts/FencView.vim'
Plugin 'vim-scripts/mru.vim'
Plugin 'vim-scripts/taglist.vim'
Plugin 'vim-scripts/TaskList.vim'
Plugin 'vim-scripts/TeTrIs.vim'
Plugin 'vim-scripts/spellcheck.vim'
Plugin 'bling/vim-airline'
Plugin 'gmarik/Vundle.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'plasticboy/vim-markdown'
Plugin 'itchyny/calendar.vim'
Plugin 'uguu-org/vim-matrix-screensaver'
Plugin 'tomasr/molokai'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'Matt-Deacalion/vim-systemd-syntax'
Plugin 'Yggdroot/indentLine'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'Valloric/ListToggle'
Plugin 'scrooloose/syntastic'
Plugin 'Valloric/YouCompleteMe'
" }
call vundle#end()                     " 插件列表必须在此之前结束
filetype plugin indent on

" ==========================
" 编辑
" ==========================
set number                            " 显示行号
set cursorline                        " 行高亮
set ruler                             " 总是显示当前光标位置
set smartindent                       " 智能对齐方式
set matchpairs=(:),[:],{:},<:>,       " % 跳转匹配
set whichwrap=b,s,<,>,[,]             " 光标行首行尾时自动移动
set expandtab                         " 空格替代tab
set smarttab                          " 智能tab
set shiftwidth=2                      " 自动缩进2 个字符
set tabstop=2                         " tab 键占2 个空格
set softtabstop=2                     " tab 键移2 个字符
set backspace=2                       " 退格键移2 个字符
set autoindent                        " 自动缩进
set ignorecase                        " 搜索时忽略大小写
set smartcase                         " 搜索内容中有大写字母才对大小写敏感
set wrapscan                          " 循环搜索
set hlsearch                          " 高亮搜索
set incsearch                         " 即时搜索及反白显示第一个匹配
set showmatch                         " 显示括号匹配
set foldenable                        " 允许折叠
set foldmethod=indent                 " 折叠方式
set foldlevel=0                       " 引发折叠的层次
set foldcolumn=1                      " 折叠为1 行
set pastetoggle=<F10>                 " 粘贴模式切换

" ==========================
" 常规
" ==========================
filetype plugin indent on             " 自动文件检测
syntax on                             " 语法高亮
set t_Co=256                          " 256 色
colorscheme molokai
if has('gui_running')
    set background=light              " 适应亮色背景
else
    set background=dark               " 适应暗色背景
endif
set history=4096                      " 历史记录长度
set showcmd                           " 回显输入的命令
set showmode                          " 显示当前的模式
set mouse=a                           " 所有模式启用鼠标
set backspace=start,indent,eol        " 解除Backspace的限制
set clipboard+=unnamed                " 关联系统的剪贴板
set encoding=utf-8                    " vim内部使用的编码方式
set fileencodings=utf-8,ucs-bom,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileformat=unix                   " 换行符风格
set iskeyword+=33-39,64               " 以下字符被看作单词的一部分
set laststatus=2                      " 总是显示状态栏
set langmenu=zh_CN.UTF-8              " GUI 菜单编码
language message zh_CN.UTF-8          " 打印信息的语言

" ==========================
" 插件
" ==========================a
" Taglist
let Tlist_Auto_Open=0
let Tlist_Auto_Update=1
let Tlist_WinWidth=25
"let Tlist_WinHeight=100
let Tlist_Show_One_File=1
let Tlist_Use_Right_Window=1
let Tlist_Use_SingleClick=1
let Tlist_Compact_Format=1
let Tlist_Exit_OnlyWindow=1
let Tlist_File_Fold_Auto_Close=1
let Tlist_GainFocus_On_ToggleOpen=1
" Fenview
let g:fencview_autodetect = 1
" Airline
let g:airline#extensions#tabline#enabled = 1
" Authorinfo
let g:vimrc_author='iSpeller'
let g:vimrc_email='shell_way@foxmail.com'
let g:vimrc_homepage='http://ispeller.sinaapp.com'
" Syntastic
" 需要flake8
let g:syntastic_check_on_open = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_enable_perl_checker = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_cpp_include_dirs = ['/usr/include/qt']
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_quiet_messages = { "type": "style" }
let g:syntastic_phpcs_conf = "--tab-width=4 --standard=CodeIgniter"
" YouCompleteMe
" 需要clang cmake llvm python2
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_invoke_completion = '<C-K>'
let g:ycm_semantic_triggers = {}
let g:ycm_semantic_triggers.c = ['->', '.', ' ', '(', '[', '&']
" Indentline
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#A4E57E'
let g:indentLine_color_light = 7
let g:ycm_collect_identifiers_from_tags_files = 0
" Molokai
let g:molokai_original = 1
let g:rehash256 = 1
" Rainbow-Parentheses
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" ==========================
" 按键映射
" ==========================
" 清空光标所在引号的内容
map cqd di"
map cqs di'
" esaymotion 快速上下跳
map zj \\w
map zk \\b
" taglist 开关
map tl :TlistToggle<CR>
" nerdtree 开关
map fl :NERDTreeToggle<CR>
" fencview 开关
map fe :FencView<CR>
" Calendar 开关
map ca :Calendar<CR>
" MRU 开关
map rf :MRU<CR>
" Authorinfo 插入和更新
nmap <F12> :AuthorInfoDetect<cr>
" YouCompleteMe
nnoremap gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <F8> :YcmForceCompileAndDiagnostics<CR>
" Trailing-Whitespace
map fw :FixWhitespace<CR>
" Drawit
map ,di :DrawIt<CR>fw
map ,ds \ds
" 快速跳转头文件
map zah :AS<CR>
map zav :AV<CR>
" 多文件缓冲跳转
map zbn :bnext<CR>
map zbp :bprevious<CR>
map zbx :bdelete<CR>
" 错误列表窗口
map lop :lopen<CR>
map lcl :lclose<CR>
" Ctrl+T 新建标签
map <C-T> <C-W>n
vmap <C-T> v<C-T>
imap <C-T> <ESC><C-T>
" Ctrl+L 黑客帝国式锁屏
map <C-L> :Matrix<CR>
vmap <C-L> v<C-L>
imap <C-L> <ESC><C-L>
" <F5> 一键保存
map <F5> :w<CR>
imap <F5> <ESC><F5>a
vmap <F5> v<F5>
" <F9> 一键编译(需要makefile)
map <F9> <F5>:make %<CR>lop
vmap <F9> v<F9>
imap <F9> <Esc><F9>a
" <F6>        <F7>
" 十六进制化  逆十六进制化
map <F6> :%!xxd<CR>
vmap <F6> v<F6>
imap <F6> <ESC><F6>
map <F7> :%!xxd -r<CR>
vmap <F7> v<F7>
imap <F7> <ESC><F7>
" Ctrl+Z  Ctrl+Y
" 撤销    重做
map <C-Z> u
vmap <C-Z> v<C-Z>
imap <C-Z> <ESC><C-Z>i
map <C-Y> <C-R>
vmap <C-Y> v<C-Y>
imap <C-Y> <ESC><C-Y>i
" Ctrl+F  Ctrl+H
" 查找    替换
map <C-F> :/
vmap <C-F> v<C-F>
imap <C-F> <Esc><C-F>
map <C-H> :%s///g<Left><Left><Left>
vmap <C-H> v<C-H>
imap <C-H> <Esc><C-H>
" Ctrl+B 快速选定鼠标所在括号所关联另一端括号之间的文本块
map <C-B> v%
vmap <C-B> %
imap <C-B> <ESC><C-B>
" Ctrl+A 全选
map <C-A> ggVG
vmap <C-A> v<C-A>
imap <C-A> <ESC><C-A>
" Ctrl+X    Ctrl+C    Ctrl+V
" X11 剪贴  X11 复制  X11 粘贴
map <C-X> "+d
imap <C-X> <ESC><C-X>i
map <C-C> "+y
imap <C-C> <ESC><C-C>i
map <C-V> <F10>"+gP<F10>
vmap <C-V> v<C-V>v
imap <C-V> <Esc>1w<C-V>a
" <F2>    <F3>    <F4>
" 下一个  上一个  取消高亮
map <F2> n
imap <F2> <ESC><F2>a
map <F3> N
imap <F3> <ESC><F3>i
map <F4> :nohlsearch<CR>
imap <F4> <ESC><F4>a

" ==========================
" Autocmd
" ==========================
if has("autocmd")
" Save the cursor localtion
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \ exe "normal! g`\"" |
    \ endif
endif

" ==========================
" GNU 缩进风格
" ==========================
" 如果不喜欢GNU 缩进风格
" 请注释掉函数后的au 一行
" ==========================
function! GnuIndent ()
  let b:did_ftplugin = 1
  setlocal cindent
  setlocal shiftwidth=2 tabstop=2 textwidth=78 softtabstop=2
  setlocal cinoptions=>2s,e-s,n-s,{1s,^-s,Ls,:s,=s,g0,+.5s,p2s,t0,(0
  setlocal formatoptions-=t formatoptions+=croql
  setlocal comments=sO:*\ -,mO:\ \ \ ,exO:*/,s1:/*,mb:\ ,ex:*/
  set cpoptions-=C
  set expandtab smarttab autoindent smartindent
endfunction
au FileType c,cpp,h,hh call GnuIndent ()

