setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=0
setlocal noexpandtab

if executable('odin')
    let s:odin_root = system('odin root')
    exec 'setlocal tags+=' . s:odin_root . '/tags'
endif

if !exists('current_compiler')
    compiler odin
    " If the project has a make file, use it (but keep the 'errorformat' from
    " the compiler plugin, so the quickfix list recognises odin)
    if filereadable('./Build.odin')
        setlocal makeprg=odin\ run\ Build.odin\ -file\ --
    elseif filereadable('./build.ninja')
        setlocal makeprg=ninja
    elseif filereadable('./Makefile')
        setlocal makeprg=make
    endif
endif

augroup AAAAAAAARRRRGGGHHHH
    autocmd!
    autocmd BufWinEnter,Colorscheme <buffer> syntax match BloodySemicolons /;$/
    autocmd BufWinEnter,Colorscheme <buffer> highlight link BloodySemicolons Error
augroup END

nnoremap <buffer> <cr> :<c-u>make!<cr>
