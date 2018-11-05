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

if empty(get(g:, 'vimfiles_dir', ''))
    if has('win32')
        let g:vimfiles_dir = expand('~/vimfiles/')
    elseif has('unix')
        let g:vimfiles_dir = expand('~/.vim/')
    endif
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
    Plug 'w0ng/vim-hybrid'

    Plug 'w0rp/ale'
    Plug 'vim-scripts/Align'
    Plug 'tpope/vim-commentary'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'tpope/vim-surround'
                \ | Plug 'tpope/vim-repeat'
                \ | Plug 'guns/vim-sexp'
                \ | Plug 'tpope/vim-sexp-mappings-for-regular-people'

    if has('python') || has('python3')
        Plug 'sirver/ultisnips'
    else
        Plug 'tomtom/tlib_vim'
                    \ | Plug 'marcweber/vim-addon-mw-utils'
                    \ | Plug 'garbas/vim-snipmate'
    endif

    Plug 'tpope/vim-fireplace'
    Plug 'tpope/vim-fugitive'
    Plug 'quabug/vim-gdscript'
    Plug 'neovimhaskell/haskell-vim'
    Plug 'bitc/vim-hdevtools'
    Plug 'jceb/vim-orgmode'
    Plug 'fsharp/vim-fsharp', {
                \ 'for': 'fsharp',
                \ 'do': 'make fsautocomplete' }
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
set spellcapcheck=

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
vnoremap <silent> * :<c-u>let b:saved_view = winsaveview()<cr>*:call winrestview(b:saved_view)<cr>gv

nnoremap <silent> <backspace> :<c-u>ALELint<cr>

" Insert Mode Bindings

noremap! <silent> <c-k> <c-r>=DigraphMenu()<cr>

inoremap <c-x><c-t> <c-x><c-]>

" Leader Key Bindings

let g:mapleader = ' '
let g:maplocalleader = 'Ö'

nnoremap <space><space> :<c-u>buffer #<cr>

nnoremap <space>a :<c-u>Ag '

if executable('ag')
    " `ag --vimgrep` does not support \<...\>
    nnoremap <space>A :<c-u>Ag '\V\C\b' . escape(expand('<cword>'), '\/') . '\b'<cr>
else
    nnoremap <space>A :<c-u>Ag '\V\C\<' . escape(expand('<cword>'), '\/') . '\>'<cr>
endif

nnoremap <space>b :<c-u>CtrlPBuffer<cr>

nnoremap <space>B :<c-u>ToggleBackground<cr>

nnoremap <space>c "+
vnoremap <space>c "+

nnoremap <space>d :<c-u>cd %:h<cr>

nnoremap <space>ec :<c-u>edit ~/.when/calendar<cr>
nnoremap <space>ed :<c-u>Vexec 'edit ++enc=cp437'<cr>
nnoremap <space>ee :<c-u>Vexec 'edit'<cr>
nnoremap <space>ef :<c-u>exec 'edit ' . fnameescape(g:vimfiles_dir . 'ftplugin/' . &filetype . '.vim')<cr>
nnoremap <space>eh :<c-u>edit <c-r>=expand('%:p:h')<cr>/
nnoremap <space>es :<c-u>exec 'edit ' . fnameescape(g:vimfiles_dir . 'snippets/' . &filetype . '.snippets')<cr>
nnoremap <space>ev :<c-u>edit $MYVIMRC<cr>

nnoremap <space>f :<c-u>CtrlP<cr>

nnoremap <space>g :<c-u>Gstatus<cr>

nnoremap <space>h :<c-u>nohlsearch<cr>

nnoremap <space>H :<c-u>ToggleSyntax<cr>

nnoremap <space>n :<c-u>set invrelativenumber<cr>

nnoremap <space>r :<c-u>Underline nr2char(getchar())<cr>
nnoremap <space>R :<c-u>Overline nr2char(getchar())<cr>

nnoremap <space>s :<c-u>%s/\v
vnoremap <space>s :s/\v

nnoremap <space>S :<c-u>sign unplace *<cr>

nnoremap <space>t :<c-u>CtrlPTag<cr>

if executable('ag')
    " `ag --vimgrep` does not support \<...\>
    nnoremap <space>T :<c-u>Ag '\C\b(TODO|FIXME|XXX)\b'<cr>
else
    nnoremap <space>T :<c-u>Ag '\v\C<(TODO|FIXME|XXX)>'<cr>
endif

nnoremap <space>ve :<c-u>edit $MYVIMRC<cr>
nnoremap <space>vh :<c-u>split $MYVIMRC<cr>
nnoremap <space>vs :<c-u>Vexec "source $MYVIMRC"<cr>
nnoremap <space>vv :<c-u>vsplit $MYVIMRC<cr>

nnoremap <space>w :<c-u>let b:saved_view = winsaveview()<cr>:CleanWhiteSpace<cr>:call winrestview(b:saved_view)<cr>
vnoremap <space>w :CleanWhiteSpace<cr>

nnoremap <space>xx :<c-u>FixSpelling<cr>
nnoremap <space>xg :<c-u>ErrorToDict<cr>
inoremap <c-x><c-x> <c-o>:FixSpelling<cr>

nnoremap <space>z zMzvzz

nnoremap <space>ö <c-]>
nnoremap <space>Ö :!ctags -R .<cr>

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

augroup DontUnderlineCursorline
    autocmd!
    autocmd ColorScheme * highlight CursorLine term=NONE cterm=NONE
augroup END


if !exists('g:loaded_vimrc')
    let &listchars = 'tab:> ,nbsp:~,eol: ,precedes:-,extends:-,trail:_'
    let &showbreak = '-'
    let s:colourscheme = 'default'
    let s:background = 'dark'

    if has('gui_running')
        set lines=35 columns=85
        set mousehide
        set guioptions=ci

        let s:background = 'light'
        call s:AwesomeListChars()
        if !empty($VIM_COLOURS)
            let s:colourscheme = $VIM_COLOURS
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
            let s:colourscheme = $VIM_COLOURS
        endif
    endif

    " :colorscheme needs to be executed at least once -- even for the default
    " scheme.  Otherwise the autocmd's from above won't fire.
    exec 'silent! colorscheme ' . s:colourscheme

    " :colorscheme keeps resetting 'background'.
    if s:colourscheme ==# 'default'
        let &background = s:background
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
    autocmd VimEnter,WinEnter,InsertLeave * set cursorline
augroup END


" PLUGIN STUFF

let g:ale_lint_on_text_changed = 0

" CtrlP

let g:ctrlp_custom_ignore = '\v\.('.
            \ '[oa]|so|dll|lib|py[co]|class|hi|exe|'.
            \ 'aux|bbl|blg|bst|dvi|log|nav|out|ps|snm|toc|fls|'.
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
            \ '-verbose',
            \ '-file-line-error',
            \ '-interaction=nonstopmode']

if has('job')
    let g:vimtex_compiler_latexmk.backend = 'jobs'
elseif has('nvim')
    let g:vimtex_compiler_latexmk.backend = 'nvim'
endif

let g:vimtex_compiler_latexmk_engines = get(g:, 'vimtex_compiler_latexmk_engines', {})
let g:vimtex_compiler_latexmk_engines['dvips'] = '-pdfps'
let g:vimtex_compiler_latexmk_engines['_'] = '-pdfps'


" SnipMate

let g:snipMate = get(g:, 'snipMate', {})
let g:snipMate.snippet_version = 1


" UltiSnips

if has('python3')
    let g:UltiSnipsUsePythonVersion = 3
elseif has('python')
    let g:UltiSnipsUsePythonVersion = 2
endif

let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<c-h>'


" General Plugin Settings

set modeline
set autoindent
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

augroup GitCommitSpelling
    autocmd!
    autocmd Filetype gitcommit setlocal spell spelllang=en_gb
augroup END


let g:loaded_vimrc=1
