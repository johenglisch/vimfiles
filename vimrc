if &compatible
    finish
endif


" FOLDERS

function! s:MkDir(dirname)
    if !isdirectory(a:dirname)
        call mkdir(a:dirname, 'p')
    endif
endfunction

if has('unix')
    let s:cache_dir  = expand('~/.cache/vim/')
else
    let s:cache_dir  = expand('~/_cache/vim/')
endif

let s:backup_dir      = s:cache_dir . 'backup/'
let s:swap_dir        = s:cache_dir . 'swap/'
let s:undo_dir        = s:cache_dir . 'undo/'
let g:ctrlp_cache_dir = s:cache_dir . 'ctrlp/'
let g:classpath_cache = s:cache_dir . 'classpath/'
let s:plugin_dir      = s:cache_dir . 'plugged/'
let g:netrw_home      = s:cache_dir

call s:MkDir(s:backup_dir)
call s:MkDir(s:swap_dir)
call s:MkDir(s:undo_dir)

exec 'set backupdir=' . fnameescape(s:backup_dir) . '/'
exec 'set directory=' . fnameescape(s:swap_dir)   . '/'
exec 'set undodir='   . fnameescape(s:undo_dir)   . '/'

if has('nvim')
    if empty($XDG_CONFIG_HOME)
        let g:vimfiles_dir = expand('~/.config/nvim/')
    else
        let g:vimfiles_dir = expand($XDG_CONFIG_HOME . '/nvim/')
    endif
elseif has('win32')
    let g:vimfiles_dir = expand('~/vimfiles/')
elseif has('unix')
    let g:vimfiles_dir = expand('~/.vim/')
endif

if has('nvim') && has('unix')
    let g:python_host_prog = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python3'
endif


" PACKAGE MANAGEMENT

let has_pluginmgr = 0
if filereadable(g:vimfiles_dir . 'autoload/plug.vim')
    let has_pluginmgr = 1
elseif confirm("Plugin manager not found.  Install it?", "&yes\n&no") == 1
    " ^^^ FIXME this confirm() isn't working on windows...

    " XXX Make Vim-plug auto-installation less platform-specific.
    let s:msg = system('curl -fLo ' . fnameescape(g:vimfiles_dir . 'autoload/plug.vim') . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')

    if v:shell_error == 0
        echomsg "Plugin manager was installed successfully"
        let has_pluginmgr = 1
    else
        echoerr "Plugin manager could not be installed:"
        echoerr s:msg
    endif
endif

if has_pluginmgr == 1
    call plug#begin(s:plugin_dir)

    "  88 colours
    Plug 'seoul'
    " 256 colours
    Plug 'romainl/Apprentice'
    " gui colours
    Plug 'altercation/vim-colors-solarized'
    Plug 'molok/vim-vombato-colorscheme'

    Plug 'mileszs/ack.vim'
    Plug 'vim-airline/vim-airline'
                \ | Plug 'vim-airline/vim-airline-themes'
    Plug 'Align'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'benekastah/neomake'
    Plug 'tomtom/tlib_vim' | Plug 'marcweber/vim-addon-mw-utils'
                \ | Plug 'garbas/vim-snipmate'
    Plug 'taglist.vim'
    Plug 'TaskList.vim'

    Plug 'tpope/vim-repeat'
                \ | Plug 'guns/vim-sexp'
    Plug 'tpope/vim-fireplace'
    Plug 'tpope/vim-fugitive'
    Plug 'vim-latex/vim-latex'
    Plug 'klen/python-mode'
    Plug 'rust-lang/rust.vim'

    call plug#end()
endif


" EDITING

if has('win32')
    set encoding=utf-8

    if !exists("loaded_vimrc")
        let $PATH .= ';C:\cygwin64\bin'
    endif
endif

if !exists("loaded_vimrc")
    set tabstop=8
    set softtabstop=4
    set shiftwidth=4
    set expandtab

    set textwidth=80
    set nowrap

    " For some reason filetype plugins love to override 'formatoptions',
    " so I have to apply brute force here... (-_-)"
    augroup ForceFormatOptions
        autocmd!
        autocmd BufEnter * set formatoptions=rqnl1
    augroup END

    set nofoldenable
endif

set undofile

set complete+=kspell

set ignorecase
set smartcase
set incsearch
set hlsearch

set showcmd

set mouse=a
set splitright
set splitbelow
set virtualedit=all
set backspace=indent,eol,start

set hidden

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

if has('nvim')
    tnoremap <C-c><C-g> <C-\><C-n>
    tnoremap <C-c><C-c> <C-c>
endif

noremap j gj
noremap k gk

noremap H ^
noremap L $

nnoremap <silent> - :<C-u>MoveLine (-(v:count1 + 1))<cr>
nnoremap <silent> + :<C-u>MoveLine v:count1<cr>

noremap Q gq
noremap QQ gqq

nnoremap ö <C-w>

nnoremap , :
vnoremap , :

noremap  ä }
noremap  Ä <C-d>
noremap  ü {
noremap  Ü <C-u>
noremap ´ @

noremap ' #
noremap # '

nnoremap <silent> * :<c-u>let b:saved_view = winsaveview()<cr>*:call winrestview(b:saved_view)<cr>
nnoremap <silent> * :<c-u>let b:saved_view = winsaveview()<cr>*:call winrestview(b:saved_view)<cr>

noremap n nzzzv
noremap N Nzzzv

noremap / /\v
noremap ? ?\v

noremap Y y$

nnoremap <backspace> :<c-u>Neomake<cr>

" Leader Key Bindings

let mapleader = ' '
let maplocalleader = 'Ö'

nnoremap <leader>d :<c-u>cd %:h<cr>

nnoremap <silent> <leader>ee :<c-u>Vexec 'edit'<cr>
nnoremap <silent> <leader>ed :<c-u>Vexec 'edit ++enc=cp437'<cr>
nnoremap <silent> <leader>ec :<c-u>edit ~/.when/calendar<cr>
nnoremap <silent> <leader>es :<c-u>exec 'edit ' . fnameescape(g:vimfiles_dir . 'snippets/' . &filetype . '.snippets')<cr>
nnoremap <silent> <leader>ef :<c-u>exec 'edit ' . fnameescape(g:vimfiles_dir . 'ftplugin/' . &filetype . '.vim')<cr>
nnoremap <silent> <leader>ev :<c-u>edit $MYVIMRC<cr>
nnoremap <leader>eh :<c-u>edit <c-r>=expand('%:p:h')<cr>/

nnoremap <leader>ve :<c-u>edit $MYVIMRC<cr>
nnoremap <leader>vh :<c-u>split $MYVIMRC<cr>
nnoremap <leader>vv :<c-u>vsplit $MYVIMRC<cr>
nnoremap <leader>vs :<c-u>Vexec "source $MYVIMRC"<cr>

nnoremap <leader>s :%s/\v
vnoremap <leader>s :s/\v
nnoremap <leader>/ :<c-u>exec 'vimgrep /'.@/.'/g %'<cr>:copen<cr>
nnoremap <leader>h :<c-u>nohlsearch<cr>

nnoremap <leader>z zMzvzz

nnoremap <leader>c "+
vnoremap <leader>c "+

nnoremap <leader>n :<c-u>set invrelativenumber<cr>
nnoremap <leader>B :<c-u>ToggleBackground<cr>
nnoremap <leader>H :<c-u>ToggleHighlighting<cr>
nnoremap <leader>S :<c-u>sign unplace *<cr>

nnoremap <leader>r :<c-u>Underline nr2char(getchar())<cr>
nnoremap <leader>R :<c-u>Overline nr2char(getchar())<cr>

nnoremap <leader>w :<c-u>let b:saved_view = winsaveview()<cr>:CleanWhiteSpace<cr>:call winrestview(b:saved_view)<cr>
vnoremap <leader>w :CleanWhiteSpace<cr>

nnoremap <leader>a :<c-u>Ack!<space>

nnoremap <leader>T :<c-u>TlistToggle<cr>

nnoremap <leader>f :<c-u>CtrlP<cr>
nnoremap <leader>b :<c-u>CtrlPBuffer<cr>

nnoremap <leader>ga :<c-u>Gwrite<cr>
nnoremap <leader>gc :<c-u>Gcommit<cr>
nnoremap <leader>gd :<c-u>Gdiff<cr>
nnoremap <leader>gg :<c-u>Git<space>
nnoremap <leader>gs :<c-u>Gstatus<cr>


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

set list
augroup DontShowListCharsInInsertMode
    autocmd!
    autocmd InsertEnter * set nolist
    autocmd InsertLeave * set list
augroup END

augroup ShowCursorLineInNormalMode
    autocmd!
    autocmd WinLeave,InsertEnter * set nocursorline
    autocmd WinEnter,InsertLeave * set cursorline
augroup END

augroup KeepSplitsEqualOnResize
    autocmd!
    autocmd VimResized * exec "normal! \<C-w>="
augroup END

function! s:AwesomeListChars()
    let &listchars = "tab:\u25b8 ,nbsp:~,eol: ,precedes:\u2190,extends:\u2192,trail:\u2592"
    let &showbreak = "\u2190"
endfunction

function! s:BoringListChars()
    let &listchars = "tab:> ,nbsp:~,eol: ,precedes:-,extends:-,trail:_"
    let &showbreak = "-"
endfunction

call s:AwesomeListChars()

if has("gui_running")
    if !exists("loaded_vimrc")
        set lines=35 columns=85
    endif

    set mousehide

    set guioptions=ci

    silent! colorscheme apprentice
    if has("gui_gtk2")
        set guifont=Liberation\ Mono\ 10
    elseif has("x11")
        set guifont=-*-terminus-medium-r-normal-*-16-*-*-*-*-*-iso10646-*
        call s:BoringListChars()
    elseif has("gui_win32")
        set guifont=Consolas:h10:cANSI
    endif
elseif $TERM =~? '.*256color.*'
    silent! colorscheme apprentice
elseif $TERM =~? '.*rxvt.*'
    set background=dark
    silent! colorscheme seoul
    let g:airline_theme = 'base16'

    call s:BoringListChars()
endif

augroup ColourColumnInInsertMode
    autocmd!
    autocmd InsertEnter * exec 'set colorcolumn='.&textwidth
    autocmd InsertLeave * set colorcolumn=0
augroup END


" PLUGIN STUFF

" Airline

set laststatus=2

let g:airline_left_sep="\u2592"
let g:airline_right_sep="\u2592"

let g:airline_extensions = ['branch', 'ctrlp', 'netrw', 'quickfix']

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

" Fireplace

let g:fireplace_no_maps = 1
let g:clojure_align_multiline_strings = 1

" Python-mode

let g:pymode_python = 'python3'

let g:pymode_options = 0
let g:pymode_trim_whitespaces = 0

let g:pymode_syntax = 0
let python_no_number_highlight = 1
let python_space_error_highlight = 1

let g:python_doc = 0
let g:pymode_breakpoint = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_lint_on_write = 0

let g:pymode_run_bind = '<cr>'
let g:pymode_rope_goto_definition_bind = 'gd'

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
    autocmd Filetype gitcommit setlocal syntax=gitcommit
    autocmd Filetype help      setlocal syntax=help
    autocmd Filetype mail      setlocal syntax=mail
    autocmd Filetype markdown  setlocal syntax=markdown
    autocmd Filetype org       setlocal syntax=org
    autocmd Filetype rst       setlocal syntax=rst
    autocmd Filetype tex       setlocal syntax=tex
augroup END

augroup OpenPDFsInBuffer
    autocmd!
    autocmd BufReadPre *.pdf silent set ro
    autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78
augroup END

highlight clear Conceal


let loaded_vimrc=1
