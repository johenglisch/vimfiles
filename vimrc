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
let s:vundle_dir      = s:cache_dir . 'vundle/'

call s:MkDir(s:backup_dir)
call s:MkDir(s:swap_dir)
call s:MkDir(s:undo_dir)

exec 'set backupdir=' . fnameescape(s:backup_dir) . '/'
exec 'set directory=' . fnameescape(s:swap_dir)   . '/'
exec 'set undodir='   . fnameescape(s:undo_dir)   . '/'


" PACKAGE MANAGEMENT

let has_vundle = 0
if isdirectory(s:vundle_dir . 'Vundle.vim')
    let has_vundle = 1
elseif confirm("Vundle not found.  Install it?", "&yes\n&no") == 1
    " ^^^ FIXME this confirm() isn't working on windows...
    call s:MkDir(s:vundle_dir)

    let s:msg = system('git clone https://github.com/gmarik/Vundle.vim.git '
                \ . '"' . s:vundle_dir . 'Vundle.vim"')
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

    exec "set runtimepath+=" . fnameescape(s:vundle_dir . "Vundle.vim")
    call vundle#begin(s:vundle_dir)

    Plugin 'gmarik/Vundle.vim'

    "  88 colours
    Plugin 'seoul'
    " 256 colours
    Plugin 'romainl/Apprentice'
    " gui colours
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'molok/vim-vombato-colorscheme'

    Plugin 'mileszs/ack.vim'
    Plugin 'kien/ctrlp.vim'
    Plugin 'taglist.vim'
    Plugin 'TaskList.vim'
    Plugin 'scrooloose/syntastic'
    Plugin 'tomtom/tlib_vim'
    Plugin 'marcweber/vim-addon-mw-utils'
    Plugin 'garbas/vim-snipmate'
    Plugin 'Align'

    Plugin 'motemen/git-vim'
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

nnoremap <silent> * :let b:saved_view = winsaveview()<cr>*:call winrestview(b:saved_view)<cr>
nnoremap <silent> * :let b:saved_view = winsaveview()<cr>*:call winrestview(b:saved_view)<cr>

noremap n nzzzv
noremap N Nzzzv

noremap / /\v
noremap ? ?\v

noremap Y y$

nnoremap <backspace> :SyntasticCheck<cr>

" Leader Key Bindings

let mapleader = ' '
let maplocalleader = 'Ö'

nnoremap <leader>d :cd %:h<cr>

nnoremap <silent> <leader>ee :Vexec 'edit'<cr>
nnoremap <silent> <leader>ed :Vexec 'edit ++enc=cp437'<cr>
nnoremap <silent> <leader>ec :edit ~/.when/calendar<cr>
nnoremap <silent> <leader>ev :edit $MYVIMRC<cr>

nnoremap <leader>ve :edit $MYVIMRC<cr>
nnoremap <leader>vh :split $MYVIMRC<cr>
nnoremap <leader>vv :vsplit $MYVIMRC<cr>
nnoremap <leader>vs :Vexec "source $MYVIMRC"<cr>

nnoremap <leader>s :%s/\v
vnoremap <leader>s :s/\v
nnoremap <leader>/ :exec 'vimgrep /'.@/.'/g %'<cr>:copen<cr>
nnoremap <leader>h :nohlsearch<cr>

nnoremap <leader>z zMzvzz

nnoremap <leader>c "+
vnoremap <leader>c "+

nnoremap <leader>B :ToggleBackground<cr>
nnoremap <leader>H :ToggleHighlighting<cr>

nnoremap <leader>r :Underline nr2char(getchar())<cr>
nnoremap <leader>R :Overline nr2char(getchar())<cr>

nnoremap <leader>w :let b:saved_view = winsaveview()<cr>:%s/\s\+$//e<cr>:call winrestview(b:saved_view)<cr>
vnoremap <leader>w :s/\s\+$//e<cr>

nnoremap <leader>T :TlistToggle<cr>

nnoremap <leader>f :<c-u>CtrlP<cr>
nnoremap <leader>b :<c-u>CtrlPBuffer<cr>

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

    silent! colorscheme solarized
    if has("gui_gtk2")
        set guifont=Liberation\ Mono\ 10
    elseif has("x11")
        set guifont=-*-terminus-medium-r-normal-*-16-*-*-*-*-*-iso10646-*
    elseif has("gui_win32")
        set guifont=Consolas:h10:cANSI
    endif
elseif &t_Co == 88
    set background=dark
    silent! colorscheme seoul
elseif &t_Co == 256
    silent! colorscheme solarized
endif

augroup ColourColumnInInsertMode
    autocmd!
    autocmd InsertEnter * exec 'set colorcolumn='.&textwidth
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
let g:pymode_trim_whitespaces = 0

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

" syntastic

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_mode_map = {
            \ "mode":              "passive",
            \ "active_filetypes":  [],
            \ "passive_filetypes": [] }

set statusline+=\ %{SyntasticStatuslineFlag()}

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
    autocmd Filetype help                setlocal syntax=help
    autocmd Filetype tex                 setlocal syntax=ON
augroup END

highlight clear Conceal


let loaded_vimrc=1
