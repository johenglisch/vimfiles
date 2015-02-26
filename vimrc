if &compatible
    finish
endif


" FOLDERS

if has('unix')
    let s:cache_dir = expand('~/.cache/vim/')
    let s:vundle_dir = expand('~/.vundle/')
else
    let s:cache_dir = expand('~/_cache/vim/')
    let s:vundle_dir = expand('~/_vundle/')
endif

exec 'set backupdir='.s:cache_dir.'backup//'
exec 'set directory='.s:cache_dir.'swap//'
exec 'set undodir='.s:cache_dir.'undo//'
let g:ctrlp_cache_dir = s:cache_dir.'ctrlp/'

if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), 'p')
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), 'p')
endif
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), 'p')
endif


" PACKAGE MANAGEMENT

let has_vundle = 0
if isdirectory(s:vundle_dir.'Vundle.vim')
    let has_vundle = 1
elseif confirm("Vundle not found.  Install it?", "&yes\n&no") == 1
    " ^^^ FIXME this confirm() isn't working on windows...
    if !isdirectory(s:vundle_dir)
        call mkdir(s:vundle_dir, 'p')
    endif

    let s:msg = system('git clone https://github.com/gmarik/Vundle.vim.git ' . shellescape(s:vundle_dir.'Vundle.vim'))
    if v:shell_error == 0
        echomsg "Vundle installation successful"
        let has_vundle = 1
    else
        echoerr "Vundle installation failed:"
        echoerr s:msg
    endif
endif

if has_vundle == 1
    filetype off

    exec "set runtimepath+=".s:vundle_dir."Vundle.vim"
    call vundle#begin(s:vundle_dir)

    Plugin 'gmarik/Vundle.vim'

    Plugin 'adobe.vim'
    Plugin 'candy.vim'
    Plugin 'nanotech/jellybeans.vim'
    Plugin 'seoul'
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'twilight'
    Plugin 'molok/vim-vombato-colorscheme'

    Plugin 'mileszs/ack.vim'
    Plugin 'DeleteTrailingWhitespace'
    Plugin 'kien/ctrlp.vim'
    Plugin 'taglist.vim'
    Plugin 'TaskList.vim'

    Plugin 'motemen/git-vim'
    Plugin 'tpope/vim-leiningen'
    Plugin 'tpope/vim-projectionist'
    Plugin 'tpope/vim-dispatch'
    Plugin 'tpope/vim-fireplace'
    Plugin 'PotatoesMaster/i3-vim-syntax'
    Plugin 'klen/python-mode'
    Plugin 'git://git.code.sf.net/p/vim-latex/vim-latex'

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

    set nowrap

    set nofoldenable
endif

set undofile

set ignorecase
set smartcase
set incsearch
set hlsearch

set showcmd
set notimeout
set nottimeout

set mouse=a
set splitright
set splitbelow
set virtualedit=all
set backspace=indent,eol,start

augroup CursorToLastKnownPosition
    autocmd!
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exec "normal g'\"zvzz" |
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

nnoremap / /\v
nnoremap ? ?\v

nnoremap Y y$
vnoremap Y y$

nnoremap <space> za
nnoremap <backspace> zn

" Leader Key Bindings

let mapleader = ','
let maplocalleader = '_'

nnoremap <silent> <leader>/ :exec 'vimgrep /'.@/.'/g %'<cr>:copen<cr>

nnoremap <silent> <leader>b :call ToggleBackground()<cr>
nnoremap <silent> <leader>c :set invcursorline invcursorcolumn<cr>

nnoremap <leader>d :cd %:h<cr>

if exists("*strftime")
    nnoremap <silent> <leader>D :echomsg strftime("%a %d %b %R")<cr>
endif

nnoremap <silent> <leader>ec :edit ~/.when/calendar<cr>
nnoremap <silent> <leader>ev :edit $MYVIMRC<cr>

" TODO: restore cursor position after switching the code page
nnoremap <silent> <leader>ee :edit ++enc=cp437<cr>

nnoremap <silent> <leader>f :<c-u>CtrlP<cr>

nnoremap <leader>h :nohlsearch<cr>

nnoremap <leader>H :ToggleHighlighting<cr>

nnoremap <silent> <leader>n :<c-u>CtrlPBuffer<cr>

nnoremap <silent> <leader>r :Underline nr2char(getchar())<cr>
nnoremap <silent> <leader>R :Overline nr2char(getchar())<cr>

nnoremap <leader>s :%s/\v

exec "nnoremap <leader>SS :source ".s:cache_dir."saved_session.vim<cr>"
exec "nnoremap <leader>SW :mksession! ".s:cache_dir."saved_session.vim<cr>"

nnoremap <silent> <leader>T :TlistToggle<cr>

nnoremap <silent> <leader>ve :edit $MYVIMRC<cr>
nnoremap <silent> <leader>vh :split $MYVIMRC<cr>
nnoremap <silent> <leader>vv :vsplit $MYVIMRC<cr>
nnoremap <silent> <leader>vs :SourceVimrc<cr>

nnoremap <leader>w :DeleteTrailingWhitespace<cr>
vnoremap <leader>w :DeleteTrailingWhitespace<cr>

nnoremap <leader>z zMzvzz

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

set lazyredraw

set visualbell t_vb=
augroup DisableVisualBellInGVim
    autocmd!
    autocmd GUIEnter * set visualbell t_vb=
augroup END

let g:loaded_matchparen=1
set showmatch

set scrolloff=1

let &listchars = "tab:\uBB ,nbsp:~,eol: ,extends:\u203A,precedes:\u2039,trail:\u2592"
set list
augroup DontShowListCharsInInsertMode
    autocmd!
    autocmd InsertEnter * set nolist
    autocmd InsertLeave * set list
augroup END

if has('gui_running')
    let &showbreak = "\u21B3"
else
    " Terminus doesn't approve cool arrows...
    let &showbreak = '> '
endif

set laststatus=2
set statusline=%<%f\ [%Y%H%M%R%W]%=%-14.((%l,%c%V)%)\ %P

augroup ShowCursorLineInNormalMode
    autocmd!
    autocmd WinLeave,InsertEnter * set nocursorline
    autocmd WinEnter,InsertLeave * set cursorline
augroup END

augroup KeepSplitsEqualOnResize
    autocmd!
    autocmd VimResized * exec "normal! \<C-w>="
augroup END

if has("gui_running")
    if !exists("loaded_vimrc")
        set lines=35 columns=85
    endif

    set mousehide

    set guioptions=ci

    set background=dark
    colorscheme solarized
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
    autocmd InsertEnter *
                \ if &background ==# 'light' |
                \   highlight ColorColumn ctermbg=LightBlue guibg=LightGrey |
                \ else |
                \   highlight ColorColumn ctermbg=DarkBlue guibg=#1A1A1A |
                \ endif |
                \ exec 'set colorcolumn='.&textwidth
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

" Ack.vim

let g:ackprg='ag --vimgrep'

" Python-mode

let g:pymode_options = 0

let g:pymode_syntax = 0
let python_no_number_highlight = 1
let python_space_error_highlight = 1

let g:python_doc = 0
let g:pymode_rope_complete_on_dot = 0

let g:pymode_run_bind = '<cr>'

" Vim LaTeX Suite

if has("win32")
    set shellslash
    set grepprg=findstr\ /N\ $*
else
    set grepprg=grep\ -nH\ $*
endif

let g:tex_flavor = 'latex'
let g:tex_conceal = 'abdmg'

" General Plugin Settings

set modeline
set autoindent
set smartindent
filetype plugin indent on

syntax manual
augroup SyntaxOnlyForCertainFiletypes
    autocmd!
    autocmd Filetype markdown            setlocal syntax=ON
    autocmd Filetype git-diff,git-status setlocal syntax=ON
augroup END

highlight clear Conceal


let loaded_vimrc=1
