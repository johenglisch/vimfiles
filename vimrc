if &compatible
    finish
endif


" GENERAL OPTIONS

set modeline

if has('unix')
    let cache_dir = expand('~/.cache/vim/')
else
    let cache_dir = expand('~/_cache/vim/')
    let g:ctrlp_cache_dir = expand('~/_cache/ctrlp/')
endif

if !isdirectory(cache_dir)
    call mkdir(cache_dir, 'p')
endif
exec 'set backupdir='.cache_dir.'/'
exec 'set directory='.cache_dir.'/'


" PACKAGE MANAGEMENT

if has('unix')
    let vundle_dir = expand('~/.vundle/')
else
    let vundle_dir = expand('~/_vundle/')
endif

let has_vundle = 0
if isdirectory(vundle_dir.'Vundle.vim')
    let has_vundle = 1
elseif confirm("Vundle not found.  Install it?", "&yes\n&no") == 1
    if !isdirectory(vundle_dir)
        call mkdir(vundle_dir, 'p')
    endif

    let msg = system('git clone https://github.com/gmarik/Vundle.vim.git ' . shellescape(vundle_dir.'Vundle.vim'))
    if v:shell_error == 0
        echomsg "Vundle installation successful"
        let has_vundle = 1
    else
        echoerr "Vundle installation failed:"
        echoerr msg
    endif

    unlet msg
endif

if has_vundle == 1
    filetype off

    exec "set runtimepath+=".vundle_dir."Vundle.vim"
    call vundle#begin(vundle_dir)

    Plugin 'gmarik/Vundle.vim'

    Plugin 'adobe.vim'
    Plugin 'candy.vim'
    Plugin 'nanotech/jellybeans.vim'
    Plugin 'seoul'
    Plugin 'twilight'
    Plugin 'molok/vim-vombato-colorscheme'
    Plugin 'Wombat'

    Plugin 'bitc/vim-bad-whitespace'
    Plugin 'kien/ctrlp.vim'
    Plugin 'TaskList.vim'
    Plugin 'scrooloose/nerdtree'
    Plugin 'taglist.vim'

    Plugin 'motemen/git-vim'
    Plugin 'PotatoesMaster/i3-vim-syntax'
    Plugin 'wting/rust.vim'
    Plugin 'klen/python-mode'
    if has('unix')
        Plugin 'git://git.code.sf.net/p/vim-latex/vim-latex'
    endif

    call vundle#end()
endif


" EDITING

if has('win32')
    set encoding=utf-8
endif

if !exists("loaded_vimrc")
    set tabstop=8
    set softtabstop=4
    set shiftwidth=4
    set expandtab

    set nofoldenable
endif

set ignorecase
set smartcase
set incsearch
set hlsearch

set showcmd
set mouse=a
set virtualedit=all
set backspace=indent,eol,start

augroup CursorToLastKnownPosition
    autocmd!
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g'\"" |
                \ endif
augroup END


" KEY BINDINGS

nnoremap <C-g> <Esc>
vnoremap <C-g> <Esc>gV
onoremap <C-g> <Esc>
inoremap <C-g> <Esc>
cnoremap <C-g> <C-c>

nnoremap ZU :w!<CR>

nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk

nnoremap H ^
vnoremap H ^
nnoremap L $
vnoremap L $

nnoremap <silent> - :MoveLineUpwards<cr>
nnoremap <silent> + :MoveLineDownwards<cr>

nnoremap Q gq
vnoremap Q gq
nnoremap QQ gqq
vnoremap QQ gqq

nnoremap ö <C-w>
nnoremap Ö :
vnoremap Ö :

noremap  ä }
noremap  Ä <C-d>
noremap  ü {
noremap  Ü <C-u>
nnoremap ´ @
vnoremap ´ @

nnoremap ' #
vnoremap ' #
nnoremap # '
vnoremap # '

nnoremap Y y$
vnoremap Y y$

nnoremap <tab> >>
nnoremap <S-tab> <<
" TODO: see if I can do this without dropping out of insert mode
inoremap <S-tab> <esc>==a

nnoremap <space> za
nnoremap <backspace> zn

" Leader Key Bindings

let mapleader = ','
let maplocalleader = '_'

nnoremap <silent> <leader>b :call ToggleBackground()<cr>
nnoremap <silent> <leader>c :set invcursorline invcursorcolumn<cr>

nnoremap <leader>d :cd %:h<cr>

if exists("*strftime")
    nnoremap <silent> <leader>D :echomsg strftime("%a %d %b %R")<cr>
endif

" TODO: restore cursor position after switching the code page
nnoremap <silent> <leader>e :edit ++enc=cp437<cr>

nnoremap <silent> <leader>f :CtrlP<cr>

nnoremap <leader>h :nohlsearch<cr>

nnoremap <silent> <leader>n :NERDTreeToggle<cr>

nnoremap <silent> <leader>r :Underline nr2char(getchar())<cr>
nnoremap <silent> <leader>R :Overline nr2char(getchar())<cr>

exec "nnoremap <leader>s :mksession! ".cache_dir."saved_session.vim<cr>"
exec "nnoremap <leader>S :source ".cache_dir."saved_sesion.vim<cr>"

nnoremap <silent> <leader>T :TlistToggle<cr>

nnoremap <silent> <leader>ve :edit $MYVIMRC<cr>
nnoremap <silent> <leader>vh :split $MYVIMRC<cr>
nnoremap <silent> <leader>vv :vsplit $MYVIMRC<cr>
nnoremap <silent> <leader>vs :SourceVimrc<cr>

nnoremap <leader>w :EraseBadWhitespace<cr>
vnoremap <leader>w :EraseBadWhitespace<cr>

" Muscle Memory Training Facilities

for prefix in ['i', 'n', 'v']
    for key in ['<up>', '<down>', '<left>', '<right>']
        exe prefix . "noremap " . key . " <nop>"
    endfor
endfor

for prefix in ['n', 'v']
    for key in ['{', '}', '<C-u>', '<C-d>']
        exe prefix . "noremap " . key . " <nop>"
    endfor
endfor


" APPEARANCE

let g:loaded_matchparen=1
set showmatch

set laststatus=2
set statusline=%<%f\ [%Y%H%M%R%W]%=%-14.((%l,%c%V)%)\ %P

if has("gui_running")
    if !exists("loaded_vimrc")
        set lines=35 columns=85
    endif

    set guioptions=ci
    set mousehide

    colorscheme twilight
    if has("gui_gtk2")
        set guifont=Liberation\ Mono\ 10
    elseif has("x11")
        set guifont=-*-terminus-medium-r-normal-*-16-*-*-*-*-*-iso10646-*
    elseif has("gui_win32")
        set guifont=Consolas:h10:cANSI
    endif
else
    set background=dark
    colorscheme seoul
endif

augroup ColourColumnInInsertMode
    autocmd!
    autocmd InsertEnter * set colorcolumn=80
    autocmd InsertLeave * set colorcolumn=0
augroup END


" PLUGIN STUFF

" Tag List

if has("win32")
    let g:Tlist_Ctags_Cmd = "C:/Users/Johannes/Documents/src/ctags58/ctags.exe"
endif

" CtrlP

if exists('g:ctrlp_custom_ignore')
    unlet g:ctrlp_custom_ignore
endif

let g:ctrlp_custom_ignore = '\v\.('.
            \ '[oa]|so|dll|lib|py[co]|class|hi|exe|'.
            \ 'aux|bbl|blg|bst|dvi|log|nav|out|pdf|ps|snm|toc|'.
            \ 'odt|doc|docx)$'

" Vim LaTeX Suite

if has("win32")
    set shellslash
    set grepprg=findstr\ /N\ $*
else
    set grepprg=grep\ -nH\ $*
endif

let g:tex_flavor = 'latex'
let g:tex_conceal = 'abdmg'

imap <C-a> <Plug>IMAP_JumpForward
nmap <C-a> <Plug>IMAP_JumpForward
vmap <C-a> <Plug>IMAP_JumpForward

" General Plugin Settings

set autoindent
set smartindent
filetype plugin indent on
syntax on

highlight clear Conceal

augroup SetColourColumnHighlighting
    autocmd!
    autocmd BufReadPost *
                \ if &background ==# 'light' |
                \   highlight ColorColumn ctermbg=LightBlue guibg=LightGrey |
                \ else |
                \   highlight ColorColumn ctermbg=DarkBlue guibg=#1A1A1A |
                \ endif
augroup END


unlet cache_dir
unlet has_vundle
unlet vundle_dir

let loaded_vimrc=1
