set encoding=utf-8
scriptencoding utf-8

" FOLDERS

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

silent! call mkdir(s:backup_dir, 'p')
silent! call mkdir(s:swap_dir, 'p')
silent! call mkdir(s:undo_dir, 'p')

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

if isdirectory($CYGWIN_BIN)
    let $PATH = $CYGWIN_BIN . ';' . $PATH
endif


" PACKAGE MANAGEMENT

let s:has_pluginmgr = 0
if filereadable(g:vimfiles_dir . 'autoload/plug.vim')
    let s:has_pluginmgr = 1
elseif confirm('Plugin manager not found.  Install it?', "&yes\n&no") == 1
    " ^^^ FIXME this confirm() isn't working on windows...

    " XXX Make Vim-plug auto-installation less platform-specific.
    let s:msg = system('curl -fLo ' . fnameescape(g:vimfiles_dir . 'autoload/plug.vim') . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')

    if v:shell_error == 0
        echomsg 'Plugin manager was installed successfully'
        let s:has_pluginmgr = 1
    else
        echoerr 'Plugin manager could not be installed:'
        echoerr s:msg
    endif
endif

if s:has_pluginmgr == 1
    call plug#begin(s:plugin_dir)

    "  88 colours
    Plug 'vim-scripts/seoul'
    " 256 colours
    Plug 'romainl/Apprentice'
    Plug 'nanotech/jellybeans.vim'
    Plug 'vim-scripts/xoria256.vim'
    " gui colours
    Plug 'vim-scripts/pyte'
    Plug 'romainl/flattened'
    Plug 'molok/vim-vombato-colorscheme'

    Plug 'vim-scripts/Align'
    Plug 'tpope/vim-commentary'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'easymotion/vim-easymotion'
    Plug 'benekastah/neomake'
    Plug 'tomtom/tlib_vim'
                \ | Plug 'marcweber/vim-addon-mw-utils'
                \ | Plug 'garbas/vim-snipmate'
    Plug 'tpope/vim-surround'
                \ | Plug 'tpope/vim-repeat'
                \ | Plug 'guns/vim-sexp'
                \ | Plug 'tpope/vim-sexp-mappings-for-regular-people'

    Plug 'tpope/vim-fireplace'
    Plug 'tpope/vim-fugitive'
    Plug 'neovimhaskell/haskell-vim'
    Plug 'bitc/vim-hdevtools'
    Plug 'jceb/vim-orgmode'
    Plug 'lervag/vimtex'
    Plug 'rust-lang/rust.vim'

    call plug#end()
endif


" EDITING

if !exists('g:loaded_vimrc')
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

if exists('&inccommand')
    set inccommand=nosplit
endif

set showcmd

set mouse=a
set splitright
set splitbelow
set virtualedit=all
set backspace=indent,eol,start

set hidden

command! Deutsch setlocal spell spelllang=de_de
command! British setlocal spell spelllang=en_gb

augroup CursorToLastKnownPosition
    autocmd!
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exec "normal! g'\"zvzz" |
                \ endif
augroup END


" KEY BINDINGS

nnoremap <C-g> <Esc>
vnoremap <C-g> <Esc>gV
onoremap <C-g> <Esc>
inoremap <C-g> <Esc>
cnoremap <C-g> <C-c>

" Normal/Visual Mode Bindings

noremap j gj
noremap k gk

noremap H ^
noremap L $

noremap ä }
noremap Ä <C-d>
noremap ü {
noremap Ü <C-u>

nnoremap ö <C-w>
nnoremap öö <C-w><C-w>
nnoremap öä :<c-u>cclose<cr>
nnoremap <c-w>ä :<c-u>cclose<cr>

noremap n nzzzv
noremap N Nzzzv

nnoremap Q @
nnoremap QQ @@

noremap Y y$

noremap , :

noremap / /\v
noremap ? ?\v

noremap ' #
noremap # `

noremap ´ Q

nnoremap <silent> - :<C-u>MoveLineUp v:count1<cr>
nnoremap <silent> + :<C-u>MoveLineDown v:count1<cr>

nnoremap <silent> * :<c-u>let b:saved_view = winsaveview()<cr>*:call winrestview(b:saved_view)<cr>
nnoremap <silent> * :<c-u>let b:saved_view = winsaveview()<cr>*:call winrestview(b:saved_view)<cr>

nnoremap <silent> <backspace> :<c-u>Neomake<cr>

" Terminal Mode Bindings

if has('nvim')
    tnoremap <C-c><C-g> <C-\><C-n>
    tnoremap <C-c><C-c> <C-c>
endif

" Insert Mode Bindings

noremap! <silent> <c-k> <c-r>=DigraphMenu()<cr>

inoremap <c-x><c-t> <c-x><c-]>

" Leader Key Bindings

let g:mapleader = ' '
let g:maplocalleader = 'Ö'

nnoremap <leader>a :<c-u>Ag '

if executable('ag')
    " `ag --vimgrep` does not support \<...\>
    nnoremap <leader>A :<c-u>Ag '\V\C\b' . escape(expand('<cword>'), '\/') . '\b'<cr>
else
    nnoremap <leader>A :<c-u>Ag '\V\C\<' . escape(expand('<cword>'), '\/') . '\>'<cr>
endif

nnoremap <leader>b :<c-u>CtrlPBuffer<cr>

nnoremap <leader>B :<c-u>ToggleBackground<cr>

nnoremap <leader>c "+
vnoremap <leader>c "+

nnoremap <leader>d :<c-u>cd %:h<cr>

nnoremap <leader>ec :<c-u>edit ~/.when/calendar<cr>
nnoremap <leader>ed :<c-u>Vexec 'edit ++enc=cp437'<cr>
nnoremap <leader>ee :<c-u>Vexec 'edit'<cr>
nnoremap <leader>ef :<c-u>exec 'edit ' . fnameescape(g:vimfiles_dir . 'ftplugin/' . &filetype . '.vim')<cr>
nnoremap <leader>eh :<c-u>edit <c-r>=expand('%:p:h')<cr>/
nnoremap <leader>es :<c-u>exec 'edit ' . fnameescape(g:vimfiles_dir . 'snippets/' . &filetype . '.snippets')<cr>
nnoremap <leader>ev :<c-u>edit $MYVIMRC<cr>

nnoremap <leader>f :<c-u>CtrlP<cr>
nnoremap <leader>F :<c-u>CtrlPMixed<cr>

nnoremap <leader>g :<c-u>Gstatus<cr>

nnoremap <leader>h :<c-u>nohlsearch<cr>

nnoremap <leader>H :<c-u>ToggleSyntax<cr>

nnoremap <leader>l :<c-u>CtrlPLine %<cr>

nnoremap <leader>n :<c-u>set invrelativenumber<cr>

nnoremap <leader>r :<c-u>Underline nr2char(getchar())<cr>
nnoremap <leader>R :<c-u>Overline nr2char(getchar())<cr>

nnoremap <leader>s :<c-u>%s/\v
vnoremap <leader>s :s/\v

nnoremap <leader>S :<c-u>sign unplace *<cr>

nnoremap <leader>t :<c-u>CtrlPTag<cr>

if executable('ag')
    " `ag --vimgrep` does not support \<...\>
    nnoremap <leader>T :<c-u>Ag '\C\b(TODO|FIXME|XXX)\b'<cr>
else
    nnoremap <leader>T :<c-u>Ag '\v\C<(TODO|FIXME|XXX)>'<cr>
endif

nnoremap <leader>ve :<c-u>edit $MYVIMRC<cr>
nnoremap <leader>vh :<c-u>split $MYVIMRC<cr>
nnoremap <leader>vs :<c-u>Vexec "source $MYVIMRC"<cr>
nnoremap <leader>vv :<c-u>vsplit $MYVIMRC<cr>

nnoremap <leader>w :<c-u>let b:saved_view = winsaveview()<cr>:CleanWhiteSpace<cr>:call winrestview(b:saved_view)<cr>
vnoremap <leader>w :CleanWhiteSpace<cr>

nnoremap <leader>xx :<c-u>FixSpelling<cr>
nnoremap <leader>xg :<c-u>ErrorToDict<cr>
inoremap <c-x><c-x> <c-o>:FixSpelling<cr>

nnoremap <leader>z zMzvzz

nnoremap <leader>ö <c-]>
nnoremap <leader>Ö :!ctags -R .<cr>

" Muscle Memory Training Facilities

for s:prefix in ['i', 'n', 'v']
    for s:key in ['<up>', '<down>', '<left>', '<right>']
        exec s:prefix . 'noremap ' . s:key . ' <nop>'
    endfor
endfor

for s:prefix in ['n', 'v']
    for s:key in ['{', '}', '<C-u>', '<C-d>']
        exec s:prefix . 'noremap ' . s:key . ' <nop>'
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

set wildmenu

set scrolloff=1


function! g:Modified() abort
    return !&modifiable ? '-' : (&modified ? '*' : '')
endfunction

function! g:GitBranch() abort
    if !exists('*fugitive#head')
        return ''
    endif
    let l:branch = fugitive#head()
    return l:branch !=# '' ? '{'.l:branch.'} ' : ''
endfunction

set laststatus=2
set statusline=%{Modified()}%t%R\ %y%=%{GitBranch()}%l:%c\ %P


set list
augroup DontShowListCharsInInsertMode
    autocmd!
    autocmd InsertEnter * set nolist
    autocmd InsertLeave * set list
augroup END

function! s:AwesomeListChars() abort
    let &listchars = "tab:\u25b8 ,nbsp:~,eol: ,precedes:\u2190,extends:\u2192,trail:\u2592"
    let &showbreak = "\u2190"
endfunction


if has('termguicolors')
    set termguicolors
endif

augroup DontColourConceals
    autocmd!
    autocmd ColorScheme * highlight clear Conceal
augroup END

augroup TermSpelling
    autocmd!
    autocmd ColorScheme * highlight SpellBad cterm=underline
    autocmd ColorScheme * highlight SpellCap cterm=underline
    autocmd ColorScheme * highlight SpellRare cterm=underline
    autocmd ColorScheme * highlight SpellLocal cterm=underline
augroup END

if !exists('g:loaded_vimrc')
    let &listchars = 'tab:> ,nbsp:~,eol: ,precedes:-,extends:-,trail:_'
    let &showbreak = '-'

    if has('gui_running')
        set lines=35 columns=85

        set mousehide

        set guioptions=ci

        call s:AwesomeListChars()

        if !empty($VIM_COLOURS)
            exec 'silent! colorscheme ' . $VIM_COLOURS
        elseif !empty(a:fallback_theme)
            exec 'silent! colorscheme ' . a:fallback_theme
        endif

        if has('gui_gtk2')
            set guifont=Hack\ 10
        elseif has('gui_win32')
            set guifont=Consolas:h10:cANSI
        endif
    elseif $TERM =~? '.*256color.*'
        set t_ut=

        call s:AwesomeListChars()

        if !empty($VIM_COLOURS)
            exec 'silent! colorscheme ' . $VIM_COLOURS
        elseif !empty(a:fallback_theme)
            exec 'silent! colorscheme ' . a:fallback_theme
        endif
    endif
endif


augroup KeepSplitsEqualOnResize
    autocmd!
    autocmd VimResized * exec "normal! \<C-w>="
augroup END

augroup ColourColumnInInsertMode
    autocmd!
    autocmd InsertEnter * exec 'set colorcolumn='.&textwidth
    autocmd InsertLeave * set colorcolumn=0
augroup END

augroup ShowCursorLineInNormalMode
    autocmd!
    autocmd WinLeave,InsertEnter * set nocursorline
    autocmd WinEnter,InsertLeave * set cursorline
augroup END


" PLUGIN STUFF

" CtrlP

if exists('g:ctrlp_custom_ignore')
    unlet g:ctrlp_custom_ignore
endif
let g:ctrlp_custom_ignore = '\v\.('.
            \ '[oa]|so|dll|lib|py[co]|class|hi|exe|'.
            \ 'aux|bbl|blg|bst|dvi|log|nav|out|pdf|ps|snm|toc|fls|'.
            \ 'fdb_latexmk|synctex\.gz|'.
            \ 'odt|doc|docx)$'

" Clojure

let g:fireplace_no_maps = 1
let g:clojure_align_multiline_strings = 1

" Haskell

let g:haskell_indent_in = 0
let g:haskell_indent_if = 0

" Org-mode

let g:org_heading_shade_leading_stars = 0

" Python

let g:python_no_number_highlight = 1
let g:python_space_error_highlight = 1

let g:neomake_python_enabled_makers = ['pyflakes3', 'pylint3']

" Rust

let g:rust_recommended_style = 0

" LaTeX

if has('win32')
    set grepprg=findstr\ /N\ $*
else
    set grepprg=grep\ -nH\ $*
endif

let g:tex_flavor = 'latex'
let g:tex_conceal = 'abdmg'

let g:vimtex_imaps_enabled = 0
let g:vimtex_matchparen_enabled = 0
let g:vimtex_text_obj_enabled = 0

let g:vimtex_compiler_latexmk = get(g:, 'vimtex_compiler_latexmk', {})
let g:vimtex_compiler_latexmk.options = [
            \ '-verbose', '-file-line-error', '-interaction=nonstopmode',
            \ '-pdfps']

" SnipMate

let g:snipMate = get(g:, 'snipMate', {})
let g:snipMate.snippet_version = 1


" General Plugin Settings

set modeline
set autoindent
set smartindent
filetype plugin indent on

runtime macros/matchit.vim

syntax manual
augroup SyntaxOnlyForCertainFiletypes
    autocmd!
    autocmd Filetype gitcommit setlocal syntax=gitcommit
    autocmd Filetype help      setlocal syntax=help
    autocmd Filetype mail      setlocal syntax=mail
    autocmd Filetype markdown  setlocal syntax=markdown
    autocmd Filetype org       setlocal syntax=org
    autocmd Filetype rst       setlocal syntax=rst
augroup END

augroup OpenPDFsInBuffer
    autocmd!
    autocmd BufReadPre *.pdf silent set ro
    autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" -
augroup END


let g:loaded_vimrc=1
