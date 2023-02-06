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
let g:classpath_cache = s:cache_dir . 'classpath/'
let s:plugin_dir      = s:cache_dir . 'plugged/'
let g:netrw_home      = s:cache_dir

silent! call mkdir(s:backup_dir, 'p')
silent! call mkdir(s:swap_dir, 'p')
silent! call mkdir(s:undo_dir, 'p')

let &backupdir = fnameescape(s:backup_dir) . '/'
let &directory = fnameescape(s:swap_dir)   . '/'
let &undodir   = fnameescape(s:undo_dir)   . '/'

if empty(get(g:, 'vimfiles_dir', ''))
    if has('win32')
        let g:vimfiles_dir = expand('~/vimfiles/')
    elseif has('unix')
        let g:vimfiles_dir = expand('~/.vim/')
    endif
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

    " 256 colours
    Plug 'nanotech/jellybeans.vim'
    " gui colours
    Plug 'romainl/flattened'
    Plug 'yasukotelin/shirotelin'
    Plug 'molok/vim-vombato-colorscheme'

    Plug 'vim-scripts/Align'
    Plug 'tpope/vim-commentary'
    if has('win32')
        Plug 'ctrlpvim/ctrlp.vim'
    else
        Plug 'junegunn/fzf'
        " fzf plugin breaks if you're not a rolling-release meme
        Plug 'junegunn/fzf.vim', { 'commit': '23dda8602f138a9d75dd03803a79733ee783e356' }
    endif
    Plug 'mattn/emmet-vim'
    Plug 'tpope/vim-surround'
                \ | Plug 'tpope/vim-repeat'
                \ | Plug 'guns/vim-sexp'
                \ | Plug 'tpope/vim-sexp-mappings-for-regular-people'

    Plug 'tomtom/tlib_vim'
                \ | Plug 'marcweber/vim-addon-mw-utils'
                \ | Plug 'garbas/vim-snipmate'

    Plug 'tpope/vim-fireplace'
    Plug 'tpope/vim-fugitive'
    Plug 'https://git.sr.ht/~sircmpwn/hare.vim'
    Plug 'tikhomirov/vim-glsl'
    Plug 'quabug/vim-gdscript'
    Plug 'sophacles/vim-bundle-mako'
    Plug 'jceb/vim-orgmode'
    Plug 'terickson001/vim-odin'
    Plug 'peterhoeg/vim-qml'
    Plug 'rust-lang/rust.vim'
    Plug 'lervag/vimtex'

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

set cpoptions+=J

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

nnoremap j gj
nnoremap k gk

noremap H ^
noremap L $

noremap ä }
noremap Ä <C-d>
noremap ü {
noremap Ü <C-u>

nnoremap ö <C-w>
nnoremap öö <C-w><C-w>
nnoremap öä :<c-u>cclose|lclose<cr>
"nnoremap öÄ :<c-u>lclose<cr>
nnoremap <c-w>ä :<c-u>cclose|lclose<cr>

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

" Insert Mode Bindings

noremap! <silent> <c-k> <c-r>=DigraphMenu()<cr>

inoremap <c-x><c-t> <c-x><c-]>

" Leader Key Bindings

nnoremap <space><space> :<c-u>buffer #<cr>

nnoremap <space>a :<c-u>Ag '

if executable('ag')
    " `ag --vimgrep` does not support \<...\>
    nnoremap <space>ga :<c-u>Ag '\V\C\b' . escape(expand('<cword>'), '\/') . '\b'<cr>
else
    nnoremap <space>ga :<c-u>Ag '\V\C\<' . escape(expand('<cword>'), '\/') . '\>'<cr>
endif

if has('win32')
    nnoremap <space>b :<c-u>CtrlPBuffer<cr>
else
    nnoremap <space>b :<c-u>Buffers<cr>
endif

nnoremap <space>B :<c-u>ToggleBackground<cr>

nnoremap <space>c "+
vnoremap <space>c "+

nnoremap <space>d :<c-u>cd %:h<cr>

nnoremap <space>ec :<c-u>edit ~/.when/calendar<cr>
nnoremap <space>ed :<c-u>Vexec 'edit ++enc=cp437'<cr>
nnoremap <space>ej :<c-u>Vexec 'edit ++enc=sjis'<cr>
nnoremap <space>ee :<c-u>Vexec 'edit'<cr>
nnoremap <space>ef :<c-u>exec 'edit ' . fnameescape(g:vimfiles_dir . 'ftplugin/' . &filetype . '.vim')<cr>
nnoremap <space>eh :<c-u>edit <c-r>=expand('%:p:h')<cr>/
nnoremap <space>es :<c-u>exec 'edit ' . fnameescape(g:vimfiles_dir . 'snippets/' . &filetype . '.snippets')<cr>
nnoremap <space>ev :<c-u>edit $MYVIMRC<cr>

if has('win32')
    nnoremap <space>f :<c-u>CtrlP<cr>
else
    nnoremap <space>f :<c-u>Files<cr>
endif

nnoremap <space>gg :<c-u>Git<cr>
nnoremap <space>gs :<c-u>Git<cr>
nnoremap <space>gw :<c-u>Gw<cr>
nnoremap <space>gc :<c-u>Git commit<cr>

nnoremap <space>h :<c-u>nohlsearch<cr>
nnoremap <space>gh :<c-u>ToggleSyntax<cr>

nnoremap <space>l :<c-u>FindCursor<cr>
nnoremap <space>gl :<c-u>Status<cr>

nnoremap <space>n :<c-u>set invnumber<cr>
nnoremap <space>gn :<c-u>set invrelativenumber<cr>

nnoremap <space>r :<c-u>Underline nr2char(getchar())<cr>
nnoremap <space>gr :<c-u>Overline nr2char(getchar())<cr>

nnoremap <space>s :<c-u>%s/\v
vnoremap <space>s :s/\v

nnoremap <space>S :<c-u>sign unplace *<cr>

if has('win32')
    nnoremap <space>t :<c-u>CtrlPTag<cr>
else
    nnoremap <space>t :<c-u>Tags<cr>
endif

if executable('ag')
    " `ag --vimgrep` does not support \<...\>
    nnoremap <space>gt :<c-u>Ag '\C\b(TODO|FIXME|XXX)\b'<cr>
else
    nnoremap <space>gt :<c-u>Ag '\v\C<(TODO|FIXME|XXX)>'<cr>
endif

nnoremap <space>ve :<c-u>edit $MYVIMRC<cr>
nnoremap <space>vh :<c-u>split $MYVIMRC<cr>
nnoremap <space>vs :<c-u>Vexec "source $MYVIMRC"<cr>
nnoremap <space>vv :<c-u>vsplit $MYVIMRC<cr>
nnoremap <space>vl :<c-u>source ./.vimrc<cr>

nnoremap <space>w :<c-u>let b:saved_view = winsaveview()<cr>:CleanWhiteSpace<cr>:call winrestview(b:saved_view)<cr>
vnoremap <space>w :CleanWhiteSpace<cr>

nnoremap <space>x :<c-u>FixSpelling<cr>
nnoremap <space>gx :<c-u>ErrorToDict<cr>
inoremap <c-x><c-x> <c-o>:FixSpelling<cr>

nnoremap <space>z zMzvzz

nnoremap <space>ö g<c-]>
nnoremap <space>gö :<c-u>!ctags -R .<cr>

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
set wildignorecase
set suffixes+=.pyc

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


if !exists('g:loaded_vimrc')
    let &listchars = 'tab:> ,nbsp:~,eol: ,precedes:-,extends:-,trail:_'
    let &showbreak = '-'

    if has('gui_running')
        set lines=35 columns=85
        set mousehide
        set guioptions=ci

        silent! colorscheme jellybeans
        call s:AwesomeListChars()

        if has('gui_gtk2')
            set guifont=Hack\ 10
        elseif has('gui_win32')
            set guifont=Consolas:h12:cANSI
        endif
    elseif $TERM =~? '.*256color.*' || $TERM ==# 'xterm-kitty'
        set t_ut=
        set termguicolors
        silent! colorscheme jellybeans

        call s:AwesomeListChars()
    endif
endif


augroup KeepSplitsEqualOnResize
    autocmd!
    autocmd VimResized * exec "normal! \<C-w>="
augroup END

augroup ColourColumnInInsertMode
    autocmd!
    autocmd InsertEnter * let &colorcolumn = &textwidth
    autocmd InsertLeave * set colorcolumn=0
augroup END


" PLUGIN STUFF

" Clojure

let g:fireplace_no_maps = 1
let g:clojure_align_multiline_strings = 1

" CtrlP

let g:ctrlp_extensions = ['tag']

" Emmet

let g:user_emmet_leader_key='<c-h>'
let g:user_emmet_install_global = 0

augroup EnableEmmet
    autocmd!
    autocmd FileType html,css,mako,markdown EmmetInstall
augroup END

" FZF

let g:fzf_preview_window = ''

" Hare

augroup WhyAreYouOverwritingMySettingsHare
    autocmd!
    autocmd FileType hare setlocal makeprg=hare
augroup END

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

let g:vimtex_quickfix_mode = 0

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
let g:vimtex_compiler_latexmk_engines['_'] = '-pdfps'
let g:vimtex_compiler_latexmk_engines['dvips'] = '-pdfps'
let g:vimtex_compiler_latexmk_engines['pdflatex'] = '-pdf'


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
set syntax=
augroup SyntaxOnlyForCertainFiletypes
    autocmd!
    autocmd Filetype fugitive  setlocal syntax=fugitive
    autocmd Filetype gitcommit setlocal syntax=gitcommit
    autocmd Filetype git       setlocal syntax=git
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
