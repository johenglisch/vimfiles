" GENERAL OPTIONS {{{

set modeline

" set directory for swap/backup/session files
if has('unix')
    let cache_dir = expand('~/.cache/vim/')
else
    let cache_dir = expand('~/_vimcache/')
endif

" create cache dir if necessary
if !isdirectory(cache_dir)
    call mkdir(cache_dir, 'p')
endif
exec 'set backupdir='.cache_dir.'/'
exec 'set directory='.cache_dir.'/'

" while editing .vimrc, reload the file on every save
augroup ReloadVimrcOnWrite
    autocmd!
    autocmd BufWritePost $MYVIMRC call ReloadVimrc()
augroup END


" }}}

" PACKAGE MANAGEMENT {{{

" set directory for vundle and its packages
if has('unix')
    let vundle_dir = expand('~/.vundle/')
else
    let vundle_dir = expand('~/_vundle/')
endif

" automatically install vundle if necessary
let has_vundle = 0
if isdirectory(vundle_dir.'Vundle.vim')
    let has_vundle = 1
elseif confirm("Vundle not found.  Install it?", "&yes\n&no") == 1
    " create vundle dir if necessary
    if !isdirectory(vundle_dir)
        call mkdir(vundle_dir, 'p')
    endif

    " install vundle from github
    let msg = system('git clone https://github.com/gmarik/Vundle.vim.git ' . shellescape(vundle_dir.'Vundle.vim'))

    " error checking
    if v:shell_error == 0
        echomsg "Vundle installation successful"
        let has_vundle = 1
    else
        echoerr "Vundle installation failed:"
        echoerr msg
    endif
endif

" init vundle
if has_vundle == 1
    exec "set runtimepath+=".vundle_dir."Vundle.vim"
    call vundle#begin(vundle_dir)

    " have vundle manage itself
    Plugin 'gmarik/Vundle.vim'

    " colour schemes
    Plugin 'seoul'

    " general plugins
    Plugin 'taglist.vim'
    Plugin 'TaskList.vim'
    Plugin 'kien/ctrlp.vim'
    Plugin 'scrooloose/nerdtree'
    Plugin 'bitc/vim-bad-whitespace'

    " filetype plugins
    Plugin 'motemen/git-vim'
    Plugin 'klen/python-mode'
    if has('unix')
        Plugin 'git://git.code.sf.net/p/vim-latex/vim-latex'
    endif

    call vundle#end()
endif


" }}}

" EDITING {{{

" force utf8 on windows
if has('win32')
    set encoding=utf-8
endif

" tab settings (not on reload because that might override ftplugins)
if !exists("loaded_vimrc")
    set tabstop=8
    set softtabstop=4
    set shiftwidth=4
    set expandtab
endif

" backspace settings
set backspace=indent,eol,start

" disable folding by default
if !exists("loaded_vimrc")
    set nofoldenable
endif

" search settings
set ignorecase
set smartcase
set incsearch
set hlsearch

" input settings
set showcmd
set mouse=a
set virtualedit=all

" place cursor to last known position
augroup PositionCursor
    autocmd!
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g'\"" |
                \ endif
augroup END


" }}}

" KEY BINDINGS {{{

" too lazy to reach for esc..
nnoremap <C-g> <Esc>
vnoremap <C-g> <Esc>gV
onoremap <C-g> <Esc>
inoremap <C-g> <Esc>
cnoremap <C-g> <C-c>

" set leader chars
let mapleader = ','
let maplocalleader = '_'

" shortcuts for writing buffers
nnoremap ZU :w!<CR>
exec "nnoremap ZM :mksession! ".cache_dir."0.vim<cr>"

" make the movement keys move across _screen_ lines
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk

" movement to line edges
nnoremap H ^
vnoremap H ^
nnoremap L $
vnoremap L $

" use - and + to move a line across the text
nnoremap <silent> - :MoveLineUpwards<cr>
nnoremap <silent> + :MoveLineDownwards<cr>

" wrap text
nnoremap Q gq
vnoremap Q gq
nnoremap QQ gqq
vnoremap QQ gqq

" faster way of switching split windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" fill that gap near my right pinkie on German keyboards
nnoremap ö /
vnoremap ö /
noremap ä }
noremap Ä <C-d>
noremap ü {
noremap Ü <C-u>
nnoremap ´ @
vnoremap ´ @

" also, swap ' and # because ' is more useful to me
nnoremap ' #
vnoremap ' #
nnoremap # '
vnoremap # '

" make Y behave like other capital letters
nnoremap Y y$
vnoremap Y y$

" make tab indent a line
nnoremap <tab> >>
nnoremap <S-tab> <<
" TODO: see if I can do this without dropping out of insert mode
inoremap <S-tab> <esc>==a

" toggle folding
nnoremap <space> za
" note: fold everything = zM
" unfold everything
nnoremap <backspace> zn

" LEADER BINDINGS

" toggle between light and dark background
nnoremap <leader>b :call ToggleBackground()<cr>

" toggle unecessarily over-the-top cursor-finder
nnoremap <silent> <leader>c :set invcursorline invcursorcolumn<cr>

" show current time
if exists("*strftime")
    nnoremap <leader>d :echomsg strftime("%a %d %b %R")<cr>
endif

" start ctrlp
nnoremap <leader>f :CtrlP<cr>

" bind nohlsearch to a key
nnoremap <leader>h :nohlsearch<cr>

" bind nerdtree to key
nnoremap <leader>n :NERDTreeToggle<cr>

" make a copy of a line and replace everything with one character
"   (useful for block comments, separators, etc)
" TODO: Implement as a function
nnoremap <leader>r yypVr
nnoremap <leader>R yyPVr

" remove trailing white space
nnoremap <silent> <leader>s :EraseBadWhitespace<cr>
vnoremap <silent> <leader>s :EraseBadWhitespace<cr>

" show taglist
nnoremap <leader>T :TlistToggle<cr>

" fast access to vimrc
nnoremap <leader>vh :split $MYVIMRC<cr>
nnoremap <leader>vv :vsplit $MYVIMRC<cr>
nnoremap <leader>vs :call ReloadVimrc()<cr>

" unbind cursor keys
for prefix in ['i', 'n', 'v']
    for key in ['<up>', '<down>', '<left>', '<right>']
        exe prefix . "noremap " . key . " <nop>"
    endfor
endfor

" unbind things that are on the umlauts now
for prefix in ['n', 'v']
    for key in ['{', '}', '<C-u>', '<C-d>']
        exe prefix . "noremap " . key . " <nop>"
    endfor
endfor


" }}}

" APPEARANCE {{{

" show matched parens only while typing
let g:loaded_matchparen=1
set showmatch

" status line
set laststatus=2
set statusline=%<%f\ [%Y%H%M%R%W]%=%-14.((%l,%c%V)%)\ %P

" gui settings
if has("gui_running")
    " keep gui to a minimum
    set guioptions=ci

    " set default window size
    if !exists("loaded_vimrc")
        set lines=35 columns=85
    endif

    " hide mouse while typing
    set mousehide

    " set font and colour theme
    colorscheme pablo
    if has("gui_gtk2")
        set guifont=DejaVu\ Sans\ Mono\ 10
    elseif has("x11")
        set guifont=-*-terminus-medium-r-normal-*-16-*-*-*-*-*-iso10646-*
    elseif has("gui_win32")
        set guifont=Consolas:h10:cANSI
    endif
else
    " default to dark terminals
    set background=dark
    colorscheme seoul
endif

" set a mark at the 80 chars border in insert mode
augroup ColorcolumnOnlyInInsertMode
    autocmd!
    autocmd InsertEnter * set colorcolumn=80
    autocmd InsertLeave * set colorcolumn=0
augroup END


" }}}

" PLUGIN STUFF {{{

" taglist config
if has("win32")
    let g:Tlist_Ctags_Cmd = "C:/Users/Johannes/Documents/src/ctags58/ctags.exe"
endif

" vim-latex config
if has("win32")
    set shellslash
    " use findstr instead of grep in windows
    set grepprg=findstr\ /N\ $*
else
    set grepprg=grep\ -nH\ $*
endif
let g:tex_flavor = 'latex'
let g:tex_conceal = 'abdmg'

" override annoying C-j mapping with C-a
imap <C-a> <Plug>IMAP_JumpForward
nmap <C-a> <Plug>IMAP_JumpForward
vmap <C-a> <Plug>IMAP_JumpForward

" indentation and syntax highlighting
set autoindent
set smartindent
filetype plugin indent on
syntax on

" set colour of the 80 char mark depending on bg
augroup HighlightColourColumn
    autocmd!
    autocmd BufReadPost *
                \ if &background ==# 'light' |
                \   highlight ColorColumn ctermbg=LightBlue guibg=LightGrey |
                \ else |
                \   highlight ColorColumn ctermbg=DarkBlue guibg=#1A1A1A |
                \ endif
augroup END

" disable distracting highlighting of concealed stuff
highlight clear Conceal


" }}}

" WILDCARDS {{{

" reset wildignore when reloading
set wildignore=

" various object/library files
set wildignore+=*.[oa]
set wildignore+=*.so
set wildignore+=*.dll
set wildignore+=*.lib
set wildignore+=*.py[co]
set wildignore+=*.class
set wildignore+=*.hi
set wildignore+=*.exe

" all that crap latex leaves behind...
set wildignore+=*.aux
set wildignore+=*.bbl
set wildignore+=*.blg
set wildignore+=*.bst
set wildignore+=*.dvi
set wildignore+=*.log  " Note: .log might be used by other programmes too
set wildignore+=*.nav
set wildignore+=*.out
set wildignore+=*.pdf
set wildignore+=*.ps
set wildignore+=*.snm
set wildignore+=*.toc

" wysiwyg documents I probably won't try and open in vim
set wildignore+=*.odt
set wildignore+=*.doc
set wildignore+=*.docx


" }}}

" RANDOM IDEAS

" " use X to clear a line
" nnoremap X 0D

let loaded_vimrc=1

" vim:foldmethod=marker:nofoldenable
