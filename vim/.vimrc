" ==============================================================================
" vim 配置文件
" 位置: ~/.vimrc
" 需要: +python, +lua
"
"           By 秦凡东
" ==============================================================================

" ==============================================================================
" Vundle
" ==============================================================================
" :PluginList           - 列出配置的插件
" :PluginInstall(!)     - 安装/更新插件
" :PluginSearch(!) foo  - 查找插件foo(首先更新缓存)
" :PluginClean(!)       - 清理被注释掉的插件
" :h vundle             - 帮助手册
" ==============================================================================
set nocompatible                      " 不兼容Vi
filetype off                          " required
set rtp+=~/.vim/bundle/Vundle.vim     " Vundle 路径
call vundle#begin()                   " call vundle#begin('~/some/path/here')
" 插件列表 {
Plugin 'airblade/vim-gitgutter'
Plugin 'bling/vim-airline'
Plugin 'chrisbra/vim-diff-enhanced'
Plugin 'easymotion/vim-easymotion'
Plugin 'flazz/vim-colorschemes'
Plugin 'gmarik/Vundle.vim'
Plugin 'hdima/python-syntax'
Plugin 'honza/vim-snippets'
Plugin 'itchyny/calendar.vim'
Plugin 'jeaye/color_coded'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'lilydjwg/colorizer'
Plugin 'majutsushi/tagbar'
Plugin 'Matt-Deacalion/vim-systemd-syntax'
Plugin 'mbbill/fencview'
Plugin 'mileszs/ack.vim'
Plugin 'morhetz/gruvbox'
"Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'ntpeters/vim-better-whitespace'
"Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'plasticboy/vim-markdown'
"Plugin 'Rip-Rip/clang_complete'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/vimshell.vim'
Plugin 'terryma/vim-multiple-cursors'
"Plugin 'tomasr/molokai'
Plugin 'uguu-org/vim-matrix-screensaver'
Plugin 'Valloric/ListToggle'
Plugin 'Valloric/vim-operator-highlight'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-perl/vim-perl'
Plugin 'vim-scripts/Align'
Plugin 'vim-scripts/a.vim'
"Plugin 'vim-scripts/bad-apple'
Plugin 'vim-scripts/c.vim'
Plugin 'vim-scripts/DrawIt'
Plugin 'vim-scripts/mru.vim'
Plugin 'vim-scripts/spellcheck.vim'
"Plugin 'vim-scripts/taglist.vim'
Plugin 'vim-scripts/TaskList.vim'
Plugin 'vim-scripts/TeTrIs.vim'
Plugin 'yonchu/accelerated-smooth-scroll'
Plugin 'Yggdroot/indentLine'
" }
call vundle#end()                     " 插件列表必须在此之前结束
filetype plugin indent on

" ==============================================================================
" 编辑
" ==============================================================================
set number                            " 显示行号
set cursorline                        " 行高亮
set cursorcolumn                      " 列高亮
set colorcolumn=81                    " 对齐线
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
" 进入插入模式光标颜色
au InsertLeave * hi Cursor guibg=cyan
" 离开插入模式光标颜色
au InsertEnter * hi Cursor guibg=green

" ==============================================================================
" 常规
" ==============================================================================
filetype plugin indent on             " 自动文件检测
syntax on                             " 语法高亮
set t_Co=256                          " 256 色
"if has('gui_running')
"    set background=light              " 适应亮色背景
"else
    set background=dark               " 适应暗色背景
"endif
colorscheme gruvbox
"colorscheme molokai
set history=4096                      " 历史记录长度
set showcmd                           " 回显输入的命令
set showmode                          " 显示当前的模式
set mouse=a                           " 所有模式启用鼠标
set backspace=start,indent,eol        " 解除Backspace的限制
set clipboard+=unnamed                " 关联系统的剪贴板
set encoding=utf-8                    " vim内部使用的编码方式
set fileencodings=utf-8,ucs-bom,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileformat=unix                   " 换行符风格
set iskeyword+=35-38,64               " 以下字符被看作单词的一部分
set laststatus=2                      " 总是显示状态栏
set langmenu=zh_CN.utf-8              " GUI 菜单编码
language message zh_CN.utf-8          " 打印信息的语言

" ==============================================================================
" manual 手册
" ==============================================================================
runtime ftplugin/man.vim
nmap ,m :Man <cword><CR>

" ==============================================================================
" 插件
" ==============================================================================
" ack.vim
let g:ackhighlight = 1
let g:ack_autoclose = 0
let g:ackpreview = 1
let g:ack_autofold_results = 0
let g:ack_qhandler = "botright copen 20"
let g:ack_lhandler = "botright lopen 20"
let g:ack_default_options =
  \ " -s -H --nocolor --nogroup --column --smart-case --follow"
" Taglist
"let Tlist_Auto_Open=0
"let Tlist_Auto_Update=1
"let Tlist_WinWidth=35
"let Tlist_Show_One_File=1
"let Tlist_Use_Right_Window=1
"let Tlist_Use_SingleClick=1
"let Tlist_Compact_Format=1
"let Tlist_Exit_OnlyWindow=1
"let Tlist_File_Fold_Auto_Close=1
"let Tlist_GainFocus_On_ToggleOpen=1
" tagbar
let g:tagbar_width = 35
let g:tagbar_indent = 2
let g:tagbar_show_linenumbers = 2
let g:tagbar_autoshowtag = 1
"let g:tagbar_autopreview = 1
" python-syntax
let python_highlight_all = 1
" accelerated-smooth-scroll
let g:ac_smooth_scroll_no_default_key_mappings = 1
" Fenview
let g:fencview_autodetect = 1
" Airline
let g:airline#extensions#tabline#enabled = 1
" vim-operator-highlight
let g:ophigh_filetypes_to_ignore = {
  \   'pod': 1,
  \   'markdown': 1,
  \   'mkd.markdown': 1,
  \   'tagbar' : 1,
  \   'qf' : 1,
  \   'notes' : 1,
  \   'unite' : 1,
  \   'text' : 1,
  \   'vimwiki' : 1,
  \   'pandoc' : 1,
  \   'infolog' : 1,
  \   'mail' : 1,
  \ }
" vim-gitgutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '*'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^-'
let g:gitgutter_sign_modified_removed = '*-'
hi GitGutterAdd ctermbg=bg guibg=bg
hi GitGutterChange ctermbg=bg guibg=bg
hi GitGutterDelete ctermbg=bg guibg=bg
hi GitGutterChangeDelete ctermbg=bg guibg=bg
" Syntastic
" 需要flake8
let g:syntastic_check_on_open = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_enable_perl_checker = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_cpp_include_dirs = ['/usr/include/qt']
let g:syntastic_cpp_compiler_options = '-std=c++11 -Wall'
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_quiet_messages = {"type": "style"}
let g:syntastic_phpcs_conf = "--tab-width=4 --standard=CodeIgniter"
" YouCompleteMe
" 需要clang cmake llvm python2
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_key_invoke_completion = '<C-N>'
let g:ycm_collect_identifiers_from_tags_files = 0
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.', ' ', '(', '[', '&'],
  \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', ' ', '(', '[', '&', '::'],
  \   'perl' : ['->', '::'],
  \   'php' : ['->', '::', '.'],
  \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }
" Indentline
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#A4E57E'
let g:indentLine_color_light = 7
" gruvbox
let g:gruvbox_termcolors = 256
let g:gruvbox_hls_cursor = 'orange'
let g:gruvbox_invert_tabline = 1
let g:gruvbox_improved_strings = 1
let g:gruvbox_improved_warnings = 1
" Molokai
"let g:molokai_original = 1
"let g:rehash256 = 1
" Rainbow-Parentheses
let g:rbpt_colorpairs = [
  \   ['brown',       'RoyalBlue3'],
  \   ['Darkblue',    'SeaGreen3'],
  \   ['darkgray',    'DarkOrchid3'],
  \   ['darkgreen',   'firebrick3'],
  \   ['darkcyan',    'RoyalBlue3'],
  \   ['darkred',     'SeaGreen3'],
  \   ['darkmagenta', 'DarkOrchid3'],
  \   ['brown',       'firebrick3'],
  \   ['gray',        'RoyalBlue3'],
  \   ['black',       'SeaGreen3'],
  \   ['darkmagenta', 'DarkOrchid3'],
  \   ['Darkblue',    'firebrick3'],
  \   ['darkgreen',   'RoyalBlue3'],
  \   ['darkcyan',    'SeaGreen3'],
  \   ['darkred',     'DarkOrchid3'],
  \   ['red',         'firebrick3'],
  \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
" vimshell.vim
let g:vimshell_prompt_expr =
  \ 'escape(fnamemodify(getcwd(), ":~").">", "\\[]()?! ")." "'
let g:vimshell_prompt_pattern = '^\%(\f\|\\.\)\+> '
" Clang Complete
let g:clang_complete_auto = 1
let g:clang_complete_copen = 1
let g:clang_hl_errors = 1
let g:clang_complete_optional_args_in_snippets = 1
let g:clang_user_options = '-std=c++11'
let g:clang_snippets = 1
let g:clang_snippets_engine = 'clang_complete'
let g:clang_auto_select = 1

" ==============================================================================
" 按键映射
" ==============================================================================
" 快速查找、替换
nmap ,f :/<C-R><C-W><CR>
nmap ,h :%s//<C-R><C-W>/g<HOME><RIGHT><RIGHT><RIGHT>
" 清空光标所在引号的内容
nmap ,cd di"
nmap ,cs di'
" ack.vim
nmap ,a :Ack<Space>
" vim-diff-enhanced
nmap ,dfm :EnhancedDiff<Space>minimal<CR>
nmap ,dfp :EnhancedDiff<Space>patience<CR>
nmap ,dfh :EnhancedDiff<Space>histogram<CR>
" esaymotion 快速上下跳
nmap zj \\w
nmap zk \\b
" vim-gitgutter
nmap gn <Plug>GitGutterNextHunk
nmap gp <Plug>GitGutterPrevHunk
" accelerated-smooth-scroll
nmap <silent> <S-J> <Plug>(ac-smooth-scroll-c-d)
nmap <silent> <S-K> <Plug>(ac-smooth-scroll-c-u)
" DrawIt
nmap ,di :DrawIt<CR>tw
nmap ,ds \ds
" taglist 开关
"nmap tl :TlistToggle<CR>
" tagbar 开关
nmap tl :TagbarToggle<CR>
" nerdtree 开关
nmap fl :NERDTreeToggle<CR>
" fencview 开关
nmap fe :FencView<CR>
" Calendar 开关
nmap ca :Calendar<CR>
" MRU
nmap rf :MRU<CR>
" YouCompleteMe
nmap go :YcmCompleter GoToDefinitionElseDeclaration<CR>
nmap <F8> :YcmForceCompileAndDiagnostics<CR>
" Toggle whitespace highlighting on/off
nmap tw :ToggleWhitespace <CR>
" Clean extra whitespace
nmap sw :StripWhitespace<CR>
" 多文件缓冲跳转
nmap bn :bnext<CR>
nmap bp :bprevious<CR>
nmap bd :only<CR>:bdelete<CR>
nmap bf :bfirst<CR>
nmap bl :blast<CR>
nmap ,b :buffer<Space>
" 错误列表窗口
nmap ,op :lopen<CR>
nmap ,cl :lclose<CR>
" vimshell.vim
nmap ,sh :VimShellCreate
" Ctrl+T 新建标签
nmap <C-T> <C-W>n
vmap <C-T> v<C-T>
imap <C-T> <ESC><C-T>
" Ctrl+L 黑客帝国式锁屏
nmap <C-L> :Matrix<CR>
vmap <C-L> v<C-L>
imap <C-L> <ESC><C-L>
" <F5> 一键保存
nmap <F5> :w<CR>
imap <F5> <ESC><F5>a
vmap <F5> v<F5>
" <F9> 一键编译(需要makefile)
nmap <F9> <F5>:make %<CR>lop
vmap <F9> v<F9>
imap <F9> <Esc><F9>a
" <F6>        <F7>
" 十六进制化  逆十六进制化
nmap <F6> :%!xxd<CR>
vmap <F6> v<F6>
imap <F6> <ESC><F6>
nmap <F7> :%!xxd -r<CR>
vmap <F7> v<F7>
imap <F7> <ESC><F7>
" Ctrl+Z  Ctrl+Y
" 撤销    重做
nmap <C-Z> u
vmap <C-Z> v<C-Z>
imap <C-Z> <ESC><C-Z>i
nmap <C-Y> <C-R>
vmap <C-Y> v<C-Y>
imap <C-Y> <ESC><C-Y>i
" Ctrl+F  Ctrl+H
" 查找    替换
nmap <C-F> :/
vmap <C-F> v<C-F>
imap <C-F> <Esc><C-F>
nmap <C-H> :%s///g<Left><Left><Left>
vmap <C-H> v<C-H>
imap <C-H> <Esc><C-H>
" Ctrl+B 快速选定鼠标所在括号所关联另一端括号之间的文本块
nmap <C-B> v%
vmap <C-B> %
imap <C-B> <ESC><C-B>
" Ctrl+A 全选
nmap <C-A> ggVG
vmap <C-A> v<C-A>
imap <C-A> <ESC><C-A>
" Ctrl+X    Ctrl+C    Ctrl+V
" X11 剪贴  X11 复制  X11 粘贴
vmap <C-X> "+d
imap <C-X> <ESC><C-X>i
vmap <C-C> "+y
imap <C-C> <ESC><C-C>i
nmap <C-V> :set paste<CR>"+gP:set nopaste<CR>
vmap <C-V> v<C-V>v
imap <C-V> <Esc>l<C-V>a
" <F2>    <F3>    <F4>
" 下一个  上一个  取消高亮
nmap <F2> n
imap <F2> <ESC><F2>a
nmap <F3> N
imap <F3> <ESC><F3>i
nmap <F4> :nohlsearch<CR>
imap <F4> <ESC><F4>a
" 分屏控制 <C-W>
" j/k/h/l       J/K/H/L       u/d                 q/o               s/v
" 分屏切换      分屏放置      上/下轮转           关闭当前/其他     水平/垂直分割
" v=/v-         h=/h-         a=/a-/e             =/-               ./,
" 垂直最大/最小 水平最大/最小 分屏最大/最小/相等  垂直增大/减小三行 水平增大/减小三行
imap <C-W> <ESC><C-W>
vmap <C-W> v<C-W>
nmap <C-W>u :wincmd R<CR>
nmap <C-W>d :wincmd r<CR>
nmap <C-W>q :q<CR>
nmap <C-W>o :only<CR>
nmap <C-W>v= :wincmd _<CR>
nmap <C-W>v- :wincmd 1_<CR>
nmap <C-W>h= :wincmd \|<CR>
nmap <C-W>h- :wincmd 1\|<CR>
nmap <C-W>a= <C-W>v=<C-W>h=
nmap <C-W>a- <C-W>v-<C-W>h-
nmap <C-W>e :wincmd =<CR>
nmap <C-W>s :split<CR>
nmap <C-W>v :vertical split<CR>
nmap <C-W>= :resize +3<CR>
nmap <C-W>- :resize -3<CR>
nmap <C-W>. :vertical resize +3<CR>
nmap <C-W>, :vertical resize -3<CR>

" ==============================================================================
" Autocmd
" ==============================================================================
if has("autocmd")
" Save the cursor localtion
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \ exe "normal! g`\"" |
    \ endif
endif

" ==============================================================================
" asm 文件使用nasm 语法
" ==============================================================================
"au FileType asm set filetype=nasm

" ==============================================================================
" GNU 缩进风格
" ==============================================================================
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
au FileType c,cpp call GnuIndent ()

" ==============================================================================
" Tab 缩进
" ==============================================================================
function! TabIndent ()
  setlocal noexpandtab smarttab
  setlocal tabstop=2 shiftwidth=2 softtabstop=2 backspace=2
endfunction
au FileType makefile,gitconfig call TabIndent ()

