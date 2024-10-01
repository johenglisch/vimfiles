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
endif

augroup AAAAAAAARRRRGGGHHHH
    autocmd!
    autocmd BufWinEnter,Colorscheme <buffer> syntax match BloodySemicolons /;$/
    autocmd BufWinEnter,Colorscheme <buffer> highlight link BloodySemicolons Error
augroup END

nnoremap <buffer> <cr> :<c-u>make!<cr>
